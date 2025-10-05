/*
 *  Copyright 2019-2025 Diligent Graphics LLC
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 *
 *  In no event and under no legal theory, whether in tort (including negligence),
 *  contract, or otherwise, unless required by applicable law (such as deliberate
 *  and grossly negligent acts) or agreed to in writing, shall any Contributor be
 *  liable for any damages, including any direct, indirect, special, incidental,
 *  or consequential damages of any character arising as a result of this License or
 *  out of the use or inability to use the software (including but not limited to damages
 *  for loss of goodwill, work stoppage, computer failure or malfunction, or any and
 *  all other commercial damages or losses), even if such Contributor has been advised
 *  of the possibility of such damages.
 */

#include "DeviceContextMtlImpl.hpp"
#include "RenderDeviceMtlImpl.hpp"
#include "PipelineStateMtlImpl.hpp"
#include "BufferMtlImpl.hpp"
#include "TextureMtlImpl.hpp"
#include "TextureViewMtlImpl.hpp"
#import <Metal/Metal.h>

namespace Diligent
{

DeviceContextMtlImpl::DeviceContextMtlImpl(IReferenceCounters*      pRefCounters,
                                           RenderDeviceMtlImpl*     pDevice,
                                           const EngineCreateInfo&  EngineCI,
                                           const DeviceContextDesc& Desc) :
    TDeviceContextBase{pRefCounters, pDevice, Desc}
{
    auto* pDeviceMtl = GetDevice();
    id<MTLDevice> mtlDevice = pDeviceMtl->GetMtlDevice();
    m_MtlCommandQueue = [mtlDevice newCommandQueue];
}

DeviceContextMtlImpl::~DeviceContextMtlImpl()
{
    if (m_MtlRenderEncoder != nil)
    {
        [m_MtlRenderEncoder endEncoding];
        [m_MtlRenderEncoder release];
        m_MtlRenderEncoder = nil;
    }
    
    if (m_MtlComputeEncoder != nil)
    {
        [m_MtlComputeEncoder endEncoding];
        [m_MtlComputeEncoder release];
        m_MtlComputeEncoder = nil;
    }
    
    if (m_MtlBlitEncoder != nil)
    {
        [m_MtlBlitEncoder endEncoding];
        [m_MtlBlitEncoder release];
        m_MtlBlitEncoder = nil;
    }
    
    if (m_MtlCommandBuffer != nil)
    {
        [m_MtlCommandBuffer release];
        m_MtlCommandBuffer = nil;
    }
    
    if (m_MtlCommandQueue != nil)
    {
        [m_MtlCommandQueue release];
        m_MtlCommandQueue = nil;
    }
}

void DeviceContextMtlImpl::Begin(Uint32 ImmediateContextId)
{
    TDeviceContextBase::Begin(ImmediateContextId, 0);
}

void DeviceContextMtlImpl::EnsureCommandBuffer()
{
    if (m_MtlCommandBuffer == nil)
    {
        m_MtlCommandBuffer = [m_MtlCommandQueue commandBuffer];
        [m_MtlCommandBuffer retain];
    }
}

void DeviceContextMtlImpl::EndAllEncoders()
{
    if (m_MtlRenderEncoder != nil)
    {
        [m_MtlRenderEncoder endEncoding];
        [m_MtlRenderEncoder release];
        m_MtlRenderEncoder = nil;
    }
    
    if (m_MtlComputeEncoder != nil)
    {
        [m_MtlComputeEncoder endEncoding];
        [m_MtlComputeEncoder release];
        m_MtlComputeEncoder = nil;
    }
    
    if (m_MtlBlitEncoder != nil)
    {
        [m_MtlBlitEncoder endEncoding];
        [m_MtlBlitEncoder release];
        m_MtlBlitEncoder = nil;
    }
}

void DeviceContextMtlImpl::SetPipelineState(IPipelineState* pPipelineState)
{
    m_pPipelineState = pPipelineState;
    
    if (m_MtlRenderEncoder != nil && pPipelineState != nullptr)
    {
        auto* pPSOMtl = static_cast<PipelineStateMtlImpl*>(pPipelineState);
        
        id<MTLRenderPipelineState> mtlPipeline = pPSOMtl->GetMtlRenderPipeline();
        if (mtlPipeline != nil)
        {
            [m_MtlRenderEncoder setRenderPipelineState:mtlPipeline];
        }
        
        id<MTLDepthStencilState> mtlDepthStencil = pPSOMtl->GetMtlDepthStencilState();
        if (mtlDepthStencil != nil)
        {
            [m_MtlRenderEncoder setDepthStencilState:mtlDepthStencil];
        }
    }
    else if (m_MtlComputeEncoder != nil && pPipelineState != nullptr)
    {
        auto* pPSOMtl = static_cast<PipelineStateMtlImpl*>(pPipelineState);
        
        id<MTLComputePipelineState> mtlPipeline = pPSOMtl->GetMtlComputePipeline();
        if (mtlPipeline != nil)
        {
            [m_MtlComputeEncoder setComputePipelineState:mtlPipeline];
        }
    }
}

void DeviceContextMtlImpl::TransitionShaderResources(IShaderResourceBinding* pShaderResourceBinding)
{
    // Metal doesn't require explicit resource transitions
    // Resources are automatically transitioned based on usage
}

void DeviceContextMtlImpl::CommitShaderResources(IShaderResourceBinding* pShaderResourceBinding, RESOURCE_STATE_TRANSITION_MODE StateTransitionMode)
{
    // Metal resource binding would be implemented here
    // This would involve setting textures, buffers, and samplers
    // For now, this is a stub
}

void DeviceContextMtlImpl::SetStencilRef(Uint32 StencilRef)
{
    if (m_MtlRenderEncoder != nil)
    {
        [m_MtlRenderEncoder setStencilReferenceValue:StencilRef];
    }
}

void DeviceContextMtlImpl::SetBlendFactors(const float* pBlendFactors)
{
    if (m_MtlRenderEncoder != nil && pBlendFactors != nullptr)
    {
        [m_MtlRenderEncoder setBlendColorRed:pBlendFactors[0]
                                       green:pBlendFactors[1]
                                        blue:pBlendFactors[2]
                                       alpha:pBlendFactors[3]];
    }
}

void DeviceContextMtlImpl::SetVertexBuffers(Uint32 StartSlot, Uint32 NumBuffersSet, IBuffer* const* ppBuffers, const Uint64* pOffsets, RESOURCE_STATE_TRANSITION_MODE StateTransitionMode, SET_VERTEX_BUFFERS_FLAGS Flags)
{
    if (m_MtlRenderEncoder == nil)
        return;
    
    for (Uint32 i = 0; i < NumBuffersSet; ++i)
    {
        if (ppBuffers[i] != nullptr)
        {
            auto* pBufferMtl = static_cast<BufferMtlImpl*>(ppBuffers[i]);
            id<MTLBuffer> mtlBuffer = pBufferMtl->GetMtlResource();
            Uint64 offset = pOffsets ? pOffsets[i] : 0;
            
            [m_MtlRenderEncoder setVertexBuffer:mtlBuffer
                                         offset:offset
                                        atIndex:StartSlot + i];
        }
    }
}

void DeviceContextMtlImpl::InvalidateState()
{
    // Invalidate cached state
    m_pPipelineState = nullptr;
}

void DeviceContextMtlImpl::SetIndexBuffer(IBuffer* pIndexBuffer, Uint64 ByteOffset, RESOURCE_STATE_TRANSITION_MODE StateTransitionMode)
{
    // Metal doesn't have a separate SetIndexBuffer call
    // Index buffer is specified in draw calls
    // Store for later use in DrawIndexed
    m_pIndexBuffer = pIndexBuffer;
    m_IndexBufferOffset = ByteOffset;
}

void DeviceContextMtlImpl::SetViewports(Uint32 NumViewports, const Viewport* pViewports, Uint32 RTWidth, Uint32 RTHeight)
{
    if (m_MtlRenderEncoder == nil || NumViewports == 0)
        return;
    
    MTLViewport mtlViewport;
    mtlViewport.originX = pViewports[0].TopLeftX;
    mtlViewport.originY = pViewports[0].TopLeftY;
    mtlViewport.width   = pViewports[0].Width;
    mtlViewport.height  = pViewports[0].Height;
    mtlViewport.znear   = pViewports[0].MinDepth;
    mtlViewport.zfar    = pViewports[0].MaxDepth;
    
    [m_MtlRenderEncoder setViewport:mtlViewport];
}

void DeviceContextMtlImpl::SetScissorRects(Uint32 NumRects, const Rect* pRects, Uint32 RTWidth, Uint32 RTHeight)
{
    if (m_MtlRenderEncoder == nil || NumRects == 0)
        return;
    
    MTLScissorRect mtlScissor;
    mtlScissor.x      = pRects[0].left;
    mtlScissor.y      = pRects[0].top;
    mtlScissor.width  = pRects[0].right - pRects[0].left;
    mtlScissor.height = pRects[0].bottom - pRects[0].top;
    
    [m_MtlRenderEncoder setScissorRect:mtlScissor];
}

void DeviceContextMtlImpl::SetRenderTargets(Uint32 NumRenderTargets, ITextureView* const* ppRenderTargets, ITextureView* pDepthStencil, RESOURCE_STATE_TRANSITION_MODE StateTransitionMode)
{
    EndAllEncoders();
    EnsureCommandBuffer();
    
    @autoreleasepool
    {
        MTLRenderPassDescriptor* renderPassDesc = [MTLRenderPassDescriptor renderPassDescriptor];
        
        for (Uint32 i = 0; i < NumRenderTargets; ++i)
        {
            if (ppRenderTargets[i] != nullptr)
            {
                auto* pRTVMtl = static_cast<TextureViewMtlImpl*>(ppRenderTargets[i]);
                id<MTLTexture> mtlTexture = pRTVMtl->GetMtlTexture();
                
                renderPassDesc.colorAttachments[i].texture = mtlTexture;
                renderPassDesc.colorAttachments[i].loadAction = MTLLoadActionLoad;
                renderPassDesc.colorAttachments[i].storeAction = MTLStoreActionStore;
            }
        }
        
        if (pDepthStencil != nullptr)
        {
            auto* pDSVMtl = static_cast<TextureViewMtlImpl*>(pDepthStencil);
            id<MTLTexture> mtlTexture = pDSVMtl->GetMtlTexture();
            
            renderPassDesc.depthAttachment.texture = mtlTexture;
            renderPassDesc.depthAttachment.loadAction = MTLLoadActionLoad;
            renderPassDesc.depthAttachment.storeAction = MTLStoreActionStore;
        }
        
        m_MtlRenderEncoder = [m_MtlCommandBuffer renderCommandEncoderWithDescriptor:renderPassDesc];
        [m_MtlRenderEncoder retain];
        
        // Reapply pipeline state if set
        if (m_pPipelineState != nullptr)
        {
            SetPipelineState(m_pPipelineState);
        }
    }
}

void DeviceContextMtlImpl::BeginRenderPass(const BeginRenderPassAttribs& Attribs)
{
    EndAllEncoders();
    EnsureCommandBuffer();
    
    // Metal doesn't use explicit render pass objects
    // Render pass is configured via MTLRenderPassDescriptor when creating render encoder
    // For now, this is a placeholder - full implementation would parse Attribs
}

void DeviceContextMtlImpl::NextSubpass()
{
    // Metal doesn't support subpasses like Vulkan
    // This would require ending current encoder and starting a new one
}

void DeviceContextMtlImpl::EndRenderPass()
{
    if (m_MtlRenderEncoder != nil)
    {
        [m_MtlRenderEncoder endEncoding];
        [m_MtlRenderEncoder release];
        m_MtlRenderEncoder = nil;
    }
}

void DeviceContextMtlImpl::Draw(const DrawAttribs& Attribs)
{
    if (m_MtlRenderEncoder == nil)
        return;
    
    [m_MtlRenderEncoder drawPrimitives:MTLPrimitiveTypeTriangle
                           vertexStart:Attribs.StartVertexLocation
                           vertexCount:Attribs.NumVertices
                         instanceCount:Attribs.NumInstances
                          baseInstance:Attribs.FirstInstanceLocation];
}

void DeviceContextMtlImpl::DrawIndexed(const DrawIndexedAttribs& Attribs)
{
    if (m_MtlRenderEncoder == nil || m_pIndexBuffer == nil)
        return;
    
    auto* pIndexBufferMtl = static_cast<BufferMtlImpl*>(m_pIndexBuffer);
    id<MTLBuffer> mtlIndexBuffer = pIndexBufferMtl->GetMtlResource();
    
    if (mtlIndexBuffer != nil)
    {
        [m_MtlRenderEncoder drawIndexedPrimitives:MTLPrimitiveTypeTriangle
                                       indexCount:Attribs.NumIndices
                                        indexType:MTLIndexTypeUInt32
                                      indexBuffer:mtlIndexBuffer
                                indexBufferOffset:m_IndexBufferOffset + Attribs.FirstIndexLocation * sizeof(Uint32)
                                    instanceCount:Attribs.NumInstances
                                       baseVertex:Attribs.BaseVertex
                                     baseInstance:Attribs.FirstInstanceLocation];
    }
}

void DeviceContextMtlImpl::DrawIndirect(const DrawIndirectAttribs& Attribs)
{
    // Stub: Draw indirect - requires more complex buffer setup
}

void DeviceContextMtlImpl::DrawIndexedIndirect(const DrawIndexedIndirectAttribs& Attribs)
{
    // Stub: Draw indexed indirect - requires more complex buffer setup
}

void DeviceContextMtlImpl::DrawMesh(const DrawMeshAttribs& Attribs)
{
    // Stub: Draw mesh
}

void DeviceContextMtlImpl::DrawMeshIndirect(const DrawMeshIndirectAttribs& Attribs)
{
    // Stub: Draw mesh indirect
}

void DeviceContextMtlImpl::DispatchCompute(const DispatchComputeAttribs& Attribs)
{
    EndAllEncoders();
    EnsureCommandBuffer();
    
    if (m_pPipelineState == nullptr)
        return;
    
    m_MtlComputeEncoder = [m_MtlCommandBuffer computeCommandEncoder];
    [m_MtlComputeEncoder retain];
    
    auto* pPSOMtl = static_cast<PipelineStateMtlImpl*>(m_pPipelineState);
    id<MTLComputePipelineState> mtlPipeline = pPSOMtl->GetMtlComputePipeline();
    
    if (mtlPipeline != nil)
    {
        [m_MtlComputeEncoder setComputePipelineState:mtlPipeline];
        
        MTLSize threadgroupSize = MTLSizeMake(Attribs.ThreadGroupCountX, Attribs.ThreadGroupCountY, Attribs.ThreadGroupCountZ);
        MTLSize threadgroups = MTLSizeMake(1, 1, 1);
        
        [m_MtlComputeEncoder dispatchThreadgroups:threadgroups
                            threadsPerThreadgroup:threadgroupSize];
    }
    
    [m_MtlComputeEncoder endEncoding];
    [m_MtlComputeEncoder release];
    m_MtlComputeEncoder = nil;
}

void DeviceContextMtlImpl::DispatchComputeIndirect(const DispatchComputeIndirectAttribs& Attribs)
{
    // Stub: Dispatch compute indirect
}

void DeviceContextMtlImpl::ClearDepthStencil(ITextureView* pView, CLEAR_DEPTH_STENCIL_FLAGS ClearFlags, float fDepth, Uint8 Stencil, RESOURCE_STATE_TRANSITION_MODE StateTransitionMode)
{
    // Clear operations in Metal are typically done via load actions in render pass
    // For explicit clears, would need to create temporary render pass
}

void DeviceContextMtlImpl::ClearRenderTarget(ITextureView* pView, const float* RGBA, RESOURCE_STATE_TRANSITION_MODE StateTransitionMode)
{
    // Clear operations in Metal are typically done via load actions in render pass
    // For explicit clears, would need to create temporary render pass
}

void DeviceContextMtlImpl::UpdateBuffer(IBuffer* pBuffer, Uint64 Offset, Uint64 Size, const void* pData, RESOURCE_STATE_TRANSITION_MODE StateTransitionMode)
{
    if (pBuffer == nullptr || pData == nullptr || Size == 0)
        return;
    
    auto* pBufferMtl = static_cast<BufferMtlImpl*>(pBuffer);
    id<MTLBuffer> mtlBuffer = pBufferMtl->GetMtlResource();
    
    if (mtlBuffer != nil)
    {
        void* pMapped = [mtlBuffer contents];
        if (pMapped != nullptr)
        {
            memcpy(static_cast<uint8_t*>(pMapped) + Offset, pData, Size);
        }
    }
}

void DeviceContextMtlImpl::CopyBuffer(IBuffer* pSrcBuffer, Uint64 SrcOffset, RESOURCE_STATE_TRANSITION_MODE SrcBufferTransitionMode, IBuffer* pDstBuffer, Uint64 DstOffset, Uint64 Size, RESOURCE_STATE_TRANSITION_MODE DstBufferTransitionMode)
{
    if (pSrcBuffer == nullptr || pDstBuffer == nullptr || Size == 0)
        return;
    
    EndAllEncoders();
    EnsureCommandBuffer();
    
    auto* pSrcBufferMtl = static_cast<BufferMtlImpl*>(pSrcBuffer);
    auto* pDstBufferMtl = static_cast<BufferMtlImpl*>(pDstBuffer);
    
    id<MTLBuffer> srcMtlBuffer = pSrcBufferMtl->GetMtlResource();
    id<MTLBuffer> dstMtlBuffer = pDstBufferMtl->GetMtlResource();
    
    m_MtlBlitEncoder = [m_MtlCommandBuffer blitCommandEncoder];
    [m_MtlBlitEncoder retain];
    
    [m_MtlBlitEncoder copyFromBuffer:srcMtlBuffer
                        sourceOffset:SrcOffset
                            toBuffer:dstMtlBuffer
                   destinationOffset:DstOffset
                                size:Size];
    
    [m_MtlBlitEncoder endEncoding];
    [m_MtlBlitEncoder release];
    m_MtlBlitEncoder = nil;
}

void DeviceContextMtlImpl::MapBuffer(IBuffer* pBuffer, MAP_TYPE MapType, MAP_FLAGS MapFlags, PVoid& pMappedData)
{
    pMappedData = nullptr;
    
    if (pBuffer == nullptr)
        return;
    
    auto* pBufferMtl = static_cast<BufferMtlImpl*>(pBuffer);
    id<MTLBuffer> mtlBuffer = pBufferMtl->GetMtlResource();
    
    if (mtlBuffer != nil)
    {
        pMappedData = [mtlBuffer contents];
    }
}

void DeviceContextMtlImpl::UnmapBuffer(IBuffer* pBuffer, MAP_TYPE MapType)
{
    // Metal buffers don't need explicit unmap
    // Data is coherent for shared storage mode
}

void DeviceContextMtlImpl::UpdateTexture(ITexture* pTexture, Uint32 MipLevel, Uint32 Slice, const Box& DstBox, const TextureSubResData& SubresData, RESOURCE_STATE_TRANSITION_MODE SrcBufferTransitionMode, RESOURCE_STATE_TRANSITION_MODE DstTextureTransitionMode)
{
    if (pTexture == nullptr || SubresData.pData == nullptr)
        return;
    
    auto* pTextureMtl = static_cast<TextureMtlImpl*>(pTexture);
    id<MTLTexture> mtlTexture = static_cast<id<MTLTexture>>(pTextureMtl->GetMtlResource());
    
    if (mtlTexture != nil)
    {
        MTLRegion region;
        region.origin = MTLOriginMake(DstBox.MinX, DstBox.MinY, DstBox.MinZ);
        region.size = MTLSizeMake(DstBox.MaxX - DstBox.MinX, DstBox.MaxY - DstBox.MinY, DstBox.MaxZ - DstBox.MinZ);
        
        [mtlTexture replaceRegion:region
                      mipmapLevel:MipLevel
                            slice:Slice
                        withBytes:SubresData.pData
                      bytesPerRow:SubresData.Stride
                    bytesPerImage:SubresData.DepthStride];
    }
}

void DeviceContextMtlImpl::CopyTexture(const CopyTextureAttribs& CopyAttribs)
{
    if (CopyAttribs.pSrcTexture == nullptr || CopyAttribs.pDstTexture == nullptr)
        return;
    
    EndAllEncoders();
    EnsureCommandBuffer();
    
    auto* pSrcTextureMtl = static_cast<TextureMtlImpl*>(CopyAttribs.pSrcTexture);
    auto* pDstTextureMtl = static_cast<TextureMtlImpl*>(CopyAttribs.pDstTexture);
    
    id<MTLTexture> srcMtlTexture = static_cast<id<MTLTexture>>(pSrcTextureMtl->GetMtlResource());
    id<MTLTexture> dstMtlTexture = static_cast<id<MTLTexture>>(pDstTextureMtl->GetMtlResource());
    
    if (srcMtlTexture != nil && dstMtlTexture != nil)
    {
        m_MtlBlitEncoder = [m_MtlCommandBuffer blitCommandEncoder];
        [m_MtlBlitEncoder retain];
        
        MTLOrigin srcOrigin = MTLOriginMake(0, 0, 0);
        MTLSize srcSize = MTLSizeMake([srcMtlTexture width], [srcMtlTexture height], [srcMtlTexture depth]);
        MTLOrigin dstOrigin = MTLOriginMake(0, 0, 0);
        
        [m_MtlBlitEncoder copyFromTexture:srcMtlTexture
                              sourceSlice:0
                              sourceLevel:0
                             sourceOrigin:srcOrigin
                               sourceSize:srcSize
                                toTexture:dstMtlTexture
                         destinationSlice:0
                         destinationLevel:0
                        destinationOrigin:dstOrigin];
        
        [m_MtlBlitEncoder endEncoding];
        [m_MtlBlitEncoder release];
        m_MtlBlitEncoder = nil;
    }
}

void DeviceContextMtlImpl::MapTextureSubresource(ITexture* pTexture, Uint32 MipLevel, Uint32 ArraySlice, MAP_TYPE MapType, MAP_FLAGS MapFlags, const Box* pMapRegion, MappedTextureSubresource& MappedData)
{
    MappedData = {};
    
    if (pTexture == nullptr)
        return;
    
    auto* pTextureMtl = static_cast<TextureMtlImpl*>(pTexture);
    id<MTLTexture> mtlTexture = static_cast<id<MTLTexture>>(pTextureMtl->GetMtlResource());
    
    if (mtlTexture != nil)
    {
        // Metal textures cannot be directly mapped
        // Would need to use a staging buffer for texture mapping
        // For now, this is a stub
    }
}

void DeviceContextMtlImpl::UnmapTextureSubresource(ITexture* pTexture, Uint32 MipLevel, Uint32 ArraySlice)
{
    // Metal textures don't support direct mapping
}

void DeviceContextMtlImpl::FinishCommandList(ICommandList** ppCommandList)
{
    // Stub: Finish command list
    if (ppCommandList)
        *ppCommandList = nullptr;
}

void DeviceContextMtlImpl::ExecuteCommandLists(Uint32 NumCommandLists, ICommandList* const* ppCommandLists)
{
    // Stub: Execute command lists
}

void DeviceContextMtlImpl::EnqueueSignal(IFence* pFence, Uint64 Value)
{
    // Stub: Enqueue signal
}

void DeviceContextMtlImpl::DeviceWaitForFence(IFence* pFence, Uint64 Value)
{
    // Stub: Device wait for fence
}

void DeviceContextMtlImpl::WaitForIdle()
{
    EndAllEncoders();
    
    if (m_MtlCommandBuffer != nil)
    {
        [m_MtlCommandBuffer commit];
        [m_MtlCommandBuffer waitUntilCompleted];
        [m_MtlCommandBuffer release];
        m_MtlCommandBuffer = nil;
    }
}

void DeviceContextMtlImpl::BeginQuery(IQuery* pQuery)
{
    // Stub: Begin query
}

void DeviceContextMtlImpl::EndQuery(IQuery* pQuery)
{
    // Stub: End query
}

void DeviceContextMtlImpl::Flush()
{
    EndAllEncoders();
    
    if (m_MtlCommandBuffer != nil)
    {
        [m_MtlCommandBuffer commit];
        [m_MtlCommandBuffer release];
        m_MtlCommandBuffer = nil;
    }
}

void DeviceContextMtlImpl::BuildBLAS(const BuildBLASAttribs& Attribs)
{
    // Stub: Build BLAS
}

void DeviceContextMtlImpl::BuildTLAS(const BuildTLASAttribs& Attribs)
{
    // Stub: Build TLAS
}

void DeviceContextMtlImpl::CopyBLAS(const CopyBLASAttribs& Attribs)
{
    // Stub: Copy BLAS
}

void DeviceContextMtlImpl::CopyTLAS(const CopyTLASAttribs& Attribs)
{
    // Stub: Copy TLAS
}

void DeviceContextMtlImpl::WriteBLASCompactedSize(const WriteBLASCompactedSizeAttribs& Attribs)
{
    // Stub: Write BLAS compacted size
}

void DeviceContextMtlImpl::WriteTLASCompactedSize(const WriteTLASCompactedSizeAttribs& Attribs)
{
    // Stub: Write TLAS compacted size
}

void DeviceContextMtlImpl::TraceRays(const TraceRaysAttribs& Attribs)
{
    // Stub: Trace rays
}

void DeviceContextMtlImpl::TraceRaysIndirect(const TraceRaysIndirectAttribs& Attribs)
{
    // Stub: Trace rays indirect
}

void DeviceContextMtlImpl::UpdateSBT(IShaderBindingTable* pSBT, const UpdateIndirectRTBufferAttribs* pUpdateIndirectBufferAttribs)
{
    // Stub: Update SBT
}

void DeviceContextMtlImpl::SetUserData(IObject* pUserData)
{
    m_pUserData = pUserData;
}

id<MTLCommandBuffer> DeviceContextMtlImpl::GetMtlCommandBuffer()
{
    EnsureCommandBuffer();
    return m_MtlCommandBuffer;
}

void DeviceContextMtlImpl::SetComputeThreadgroupMemoryLength(Uint32 Length, Uint32 Index)
{
    // Stub: Set compute threadgroup memory length
}

void DeviceContextMtlImpl::SetTileThreadgroupMemoryLength(Uint32 Length, Uint32 Index)
{
    // Stub: Set tile threadgroup memory length
}

} // namespace Diligent
