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
#import <Metal/Metal.h>

namespace Diligent
{

DeviceContextMtlImpl::DeviceContextMtlImpl(IReferenceCounters*      pRefCounters,
                                           RenderDeviceMtlImpl*     pDevice,
                                           const EngineCreateInfo&  EngineCI,
                                           const DeviceContextDesc& Desc) :
    TDeviceContextBase{pRefCounters, pDevice, Desc}
{
    // This is a stub implementation
    // Full command encoding implementation would be added here
}

DeviceContextMtlImpl::~DeviceContextMtlImpl()
{
    if (m_MtlCommandBuffer != nil)
    {
        [m_MtlCommandBuffer release];
        m_MtlCommandBuffer = nil;
    }
}

void DeviceContextMtlImpl::Begin(Uint32 ImmediateContextId)
{
    TDeviceContextBase::Begin(ImmediateContextId, 0);
}

void DeviceContextMtlImpl::SetPipelineState(IPipelineState* pPipelineState)
{
    // Stub: Set pipeline state
}

void DeviceContextMtlImpl::TransitionShaderResources(IShaderResourceBinding* pShaderResourceBinding)
{
    // Stub: Transition shader resources
}

void DeviceContextMtlImpl::CommitShaderResources(IShaderResourceBinding* pShaderResourceBinding, RESOURCE_STATE_TRANSITION_MODE StateTransitionMode)
{
    // Stub: Commit shader resources
}

void DeviceContextMtlImpl::SetStencilRef(Uint32 StencilRef)
{
    // Stub: Set stencil reference
}

void DeviceContextMtlImpl::SetBlendFactors(const float* pBlendFactors)
{
    // Stub: Set blend factors
}

void DeviceContextMtlImpl::SetVertexBuffers(Uint32 StartSlot, Uint32 NumBuffersSet, IBuffer* const* ppBuffers, const Uint64* pOffsets, RESOURCE_STATE_TRANSITION_MODE StateTransitionMode, SET_VERTEX_BUFFERS_FLAGS Flags)
{
    // Stub: Set vertex buffers
}

void DeviceContextMtlImpl::InvalidateState()
{
    // Stub: Invalidate state
}

void DeviceContextMtlImpl::SetIndexBuffer(IBuffer* pIndexBuffer, Uint64 ByteOffset, RESOURCE_STATE_TRANSITION_MODE StateTransitionMode)
{
    // Stub: Set index buffer
}

void DeviceContextMtlImpl::SetViewports(Uint32 NumViewports, const Viewport* pViewports, Uint32 RTWidth, Uint32 RTHeight)
{
    // Stub: Set viewports
}

void DeviceContextMtlImpl::SetScissorRects(Uint32 NumRects, const Rect* pRects, Uint32 RTWidth, Uint32 RTHeight)
{
    // Stub: Set scissor rects
}

void DeviceContextMtlImpl::SetRenderTargets(Uint32 NumRenderTargets, ITextureView* const* ppRenderTargets, ITextureView* pDepthStencil, RESOURCE_STATE_TRANSITION_MODE StateTransitionMode)
{
    // Stub: Set render targets
}

void DeviceContextMtlImpl::BeginRenderPass(const BeginRenderPassAttribs& Attribs)
{
    // Stub: Begin render pass
}

void DeviceContextMtlImpl::NextSubpass()
{
    // Stub: Next subpass
}

void DeviceContextMtlImpl::EndRenderPass()
{
    // Stub: End render pass
}

void DeviceContextMtlImpl::Draw(const DrawAttribs& Attribs)
{
    // Stub: Draw
}

void DeviceContextMtlImpl::DrawIndexed(const DrawIndexedAttribs& Attribs)
{
    // Stub: Draw indexed
}

void DeviceContextMtlImpl::DrawIndirect(const DrawIndirectAttribs& Attribs)
{
    // Stub: Draw indirect
}

void DeviceContextMtlImpl::DrawIndexedIndirect(const DrawIndexedIndirectAttribs& Attribs)
{
    // Stub: Draw indexed indirect
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
    // Stub: Dispatch compute
}

void DeviceContextMtlImpl::DispatchComputeIndirect(const DispatchComputeIndirectAttribs& Attribs)
{
    // Stub: Dispatch compute indirect
}

void DeviceContextMtlImpl::ClearDepthStencil(ITextureView* pView, CLEAR_DEPTH_STENCIL_FLAGS ClearFlags, float fDepth, Uint8 Stencil, RESOURCE_STATE_TRANSITION_MODE StateTransitionMode)
{
    // Stub: Clear depth stencil
}

void DeviceContextMtlImpl::ClearRenderTarget(ITextureView* pView, const float* RGBA, RESOURCE_STATE_TRANSITION_MODE StateTransitionMode)
{
    // Stub: Clear render target
}

void DeviceContextMtlImpl::UpdateBuffer(IBuffer* pBuffer, Uint64 Offset, Uint64 Size, const void* pData, RESOURCE_STATE_TRANSITION_MODE StateTransitionMode)
{
    // Stub: Update buffer
}

void DeviceContextMtlImpl::CopyBuffer(IBuffer* pSrcBuffer, Uint64 SrcOffset, RESOURCE_STATE_TRANSITION_MODE SrcBufferTransitionMode, IBuffer* pDstBuffer, Uint64 DstOffset, Uint64 Size, RESOURCE_STATE_TRANSITION_MODE DstBufferTransitionMode)
{
    // Stub: Copy buffer
}

void DeviceContextMtlImpl::MapBuffer(IBuffer* pBuffer, MAP_TYPE MapType, MAP_FLAGS MapFlags, PVoid& pMappedData)
{
    // Stub: Map buffer
    pMappedData = nullptr;
}

void DeviceContextMtlImpl::UnmapBuffer(IBuffer* pBuffer, MAP_TYPE MapType)
{
    // Stub: Unmap buffer
}

void DeviceContextMtlImpl::UpdateTexture(ITexture* pTexture, Uint32 MipLevel, Uint32 Slice, const Box& DstBox, const TextureSubResData& SubresData, RESOURCE_STATE_TRANSITION_MODE SrcBufferTransitionMode, RESOURCE_STATE_TRANSITION_MODE DstTextureTransitionMode)
{
    // Stub: Update texture
}

void DeviceContextMtlImpl::CopyTexture(const CopyTextureAttribs& CopyAttribs)
{
    // Stub: Copy texture
}

void DeviceContextMtlImpl::MapTextureSubresource(ITexture* pTexture, Uint32 MipLevel, Uint32 ArraySlice, MAP_TYPE MapType, MAP_FLAGS MapFlags, const Box* pMapRegion, MappedTextureSubresource& MappedData)
{
    // Stub: Map texture subresource
    MappedData = {};
}

void DeviceContextMtlImpl::UnmapTextureSubresource(ITexture* pTexture, Uint32 MipLevel, Uint32 ArraySlice)
{
    // Stub: Unmap texture subresource
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
    // Stub: Wait for idle
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
    // Stub: Flush
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
