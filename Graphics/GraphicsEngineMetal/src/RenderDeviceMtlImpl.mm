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

#include "RenderDeviceMtlImpl.hpp"
#include "ShaderMtlImpl.hpp"
#include "PipelineStateMtlImpl.hpp"
#include "BufferMtlImpl.hpp"
#include "TextureMtlImpl.hpp"
#include "SamplerMtlImpl.hpp"
#include "FenceMtlImpl.hpp"
#include "DebugUtilities.hpp"

#import <Metal/Metal.h>

namespace Diligent
{

RenderDeviceMtlImpl::RenderDeviceMtlImpl(IReferenceCounters*        pRefCounters,
                                         IMemoryAllocator&          RawMemAllocator,
                                         IEngineFactory*            pEngineFactory,
                                         const EngineCreateInfo&    EngineCI,
                                         const GraphicsAdapterInfo& AdapterInfo) noexcept(false) :
    TRenderDeviceBase{pRefCounters, RawMemAllocator, pEngineFactory, EngineCI, AdapterInfo}
{
    m_MtlDevice = MTLCreateSystemDefaultDevice();
}

RenderDeviceMtlImpl::~RenderDeviceMtlImpl()
{
    if (m_MtlDevice != nil)
    {
        [m_MtlDevice release];
        m_MtlDevice = nil;
    }
}

void RenderDeviceMtlImpl::CreateGraphicsPipelineState(const GraphicsPipelineStateCreateInfo& PSOCreateInfo,
                                                      IPipelineState**                       ppPipelineState)
{
    CreatePipelineStateImpl(ppPipelineState, PSOCreateInfo);
}

void RenderDeviceMtlImpl::CreateComputePipelineState(const ComputePipelineStateCreateInfo& PSOCreateInfo,
                                                     IPipelineState**                      ppPipelineState)
{
    CreatePipelineStateImpl(ppPipelineState, PSOCreateInfo);
}

void RenderDeviceMtlImpl::CreateBuffer(const BufferDesc& BuffDesc,
                                       const BufferData* pBuffData,
                                       IBuffer**         ppBuffer)
{
    CreateBufferImpl(ppBuffer, BuffDesc, pBuffData);
}

void RenderDeviceMtlImpl::CreateShader(const ShaderCreateInfo& ShaderCreateInfo,
                                       IShader**               ppShader,
                                       IDataBlob**             ppCompilerOutput)
{
    CreateShaderImpl(ppShader, ShaderCreateInfo, ppCompilerOutput);
}

void RenderDeviceMtlImpl::CreateTexture(const TextureDesc& TexDesc,
                                        const TextureData* pData,
                                        ITexture**         ppTexture)
{
    CreateTextureImpl(ppTexture, TexDesc, pData);
}

void RenderDeviceMtlImpl::CreateSampler(const SamplerDesc& SamplerDesc,
                                        ISampler**         ppSampler)
{
    CreateSamplerImpl(ppSampler, SamplerDesc);
}

void RenderDeviceMtlImpl::CreateFence(const FenceDesc& Desc,
                                      IFence**         ppFence)
{
    CreateFenceImpl(ppFence, Desc);
}

void RenderDeviceMtlImpl::CreateQuery(const QueryDesc& Desc,
                                      IQuery**         ppQuery)
{
    CreateQueryImpl(ppQuery, Desc);
}

id<MTLDevice> RenderDeviceMtlImpl::GetMtlDevice() const
{
    return m_MtlDevice;
}

void RenderDeviceMtlImpl::CreateTextureFromMtlResource(id<MTLTexture> mtlTexture,
                                                       RESOURCE_STATE InitialState,
                                                       ITexture**     ppTexture)
{
    // For now, we need to extract the TextureDesc from the Metal texture
    // This is a stub implementation that needs proper Metal texture description extraction
    TextureDesc TexDesc;
    // TODO: Extract texture description from mtlTexture
    CreateTextureImpl(ppTexture, TexDesc, InitialState, mtlTexture);
}

void RenderDeviceMtlImpl::CreateBufferFromMtlResource(id<MTLBuffer>     mtlBuffer,
                                                      const BufferDesc& BuffDesc,
                                                      RESOURCE_STATE    InitialState,
                                                      IBuffer**         ppBuffer)
{
    CreateBufferImpl(ppBuffer, BuffDesc, InitialState, mtlBuffer);
}

void RenderDeviceMtlImpl::CreateSparseTexture(const TextureDesc& TexDesc,
                                              IDeviceMemory*     pMemory,
                                              ITexture**         ppTexture)
{
    // Sparse textures not yet implemented for Metal backend
    LOG_ERROR_MESSAGE("CreateSparseTexture is not yet implemented for Metal backend");
    *ppTexture = nullptr;
}

void RenderDeviceMtlImpl::CreateRayTracingPipelineState(const RayTracingPipelineStateCreateInfo& PSOCreateInfo,
                                                        IPipelineState**                         ppPipelineState)
{
    UNSUPPORTED("Ray tracing is not yet implemented for Metal backend");
    *ppPipelineState = nullptr;
}

void RenderDeviceMtlImpl::CreateRenderPass(const RenderPassDesc& Desc,
                                           IRenderPass**         ppRenderPass)
{
    CreateRenderPassImpl(ppRenderPass, Desc);
}

void RenderDeviceMtlImpl::CreateFramebuffer(const FramebufferDesc& Desc,
                                            IFramebuffer**         ppFramebuffer)
{
    CreateFramebufferImpl(ppFramebuffer, Desc);
}

void RenderDeviceMtlImpl::CreateBLAS(const BottomLevelASDesc& Desc,
                                     IBottomLevelAS**         ppBLAS)
{
    UNSUPPORTED("CreateBLAS is not yet implemented for Metal backend");
    *ppBLAS = nullptr;
}

void RenderDeviceMtlImpl::CreateTLAS(const TopLevelASDesc& Desc,
                                     ITopLevelAS**         ppTLAS)
{
    UNSUPPORTED("CreateTLAS is not yet implemented for Metal backend");
    *ppTLAS = nullptr;
}

void RenderDeviceMtlImpl::CreateSBT(const ShaderBindingTableDesc& Desc,
                                    IShaderBindingTable**         ppSBT)
{
    UNSUPPORTED("CreateSBT is not yet implemented for Metal backend");
    *ppSBT = nullptr;
}

void RenderDeviceMtlImpl::CreatePipelineResourceSignature(const PipelineResourceSignatureDesc& Desc,
                                                          IPipelineResourceSignature**         ppSignature)
{
    CreatePipelineResourceSignatureImpl(ppSignature, Desc, SHADER_TYPE_UNKNOWN, false);
}

void RenderDeviceMtlImpl::CreateDeviceMemory(const DeviceMemoryCreateInfo& CreateInfo,
                                             IDeviceMemory**               ppMemory)
{
    CreateDeviceMemoryImpl(ppMemory, CreateInfo);
}

void RenderDeviceMtlImpl::CreatePipelineStateCache(const PipelineStateCacheCreateInfo& CreateInfo,
                                                   IPipelineStateCache**               ppPSOCache)
{
    // Pipeline state cache not yet implemented for Metal backend
    *ppPSOCache = nullptr;
}

void RenderDeviceMtlImpl::CreateDeferredContext(IDeviceContext** ppContext)
{
    UNSUPPORTED("Deferred contexts are not supported in Metal backend");
    *ppContext = nullptr;
}

SparseTextureFormatInfo RenderDeviceMtlImpl::GetSparseTextureFormatInfo(TEXTURE_FORMAT     TexFormat,
                                                                        RESOURCE_DIMENSION Dimension,
                                                                        Uint32             SampleCount) const
{
    // Sparse textures not yet supported in Metal backend
    return TRenderDeviceBase::GetSparseTextureFormatInfo(TexFormat, Dimension, SampleCount);
}

void RenderDeviceMtlImpl::ReleaseStaleResources(bool ForceRelease)
{
    // Metal resource management is handled by ARC
    // Stub implementation for now
}

void RenderDeviceMtlImpl::IdleGPU()
{
    // Wait for all GPU operations to complete
    // Stub implementation for now
}

void RenderDeviceMtlImpl::CreateBLASFromMtlResource(id<MTLAccelerationStructure> mtlBLAS,
                                                    const BottomLevelASDesc&     Desc,
                                                    RESOURCE_STATE               InitialState,
                                                    IBottomLevelAS**             ppBLAS)
{
    UNSUPPORTED("CreateBLASFromMtlResource is not yet implemented for Metal backend");
    *ppBLAS = nullptr;
}

void RenderDeviceMtlImpl::CreateTLASFromMtlResource(id<MTLAccelerationStructure> mtlTLAS,
                                                    const TopLevelASDesc&        Desc,
                                                    RESOURCE_STATE               InitialState,
                                                    ITopLevelAS**                ppTLAS)
{
    UNSUPPORTED("CreateTLASFromMtlResource is not yet implemented for Metal backend");
    *ppTLAS = nullptr;
}

void RenderDeviceMtlImpl::CreateRasterizationRateMapFromMtlResource(id<MTLRasterizationRateMap> mtlRRM,
                                                                    IRasterizationRateMapMtl**  ppRRM)
{
    UNSUPPORTED("CreateRasterizationRateMapFromMtlResource is not yet implemented for Metal backend");
    *ppRRM = nullptr;
}

void RenderDeviceMtlImpl::CreateRasterizationRateMap(const RasterizationRateMapCreateInfo& CreateInfo,
                                                     IRasterizationRateMapMtl**            ppRRM)
{
    UNSUPPORTED("CreateRasterizationRateMap is not yet implemented for Metal backend");
    *ppRRM = nullptr;
}

void RenderDeviceMtlImpl::TestTextureFormat(TEXTURE_FORMAT TexFormat)
{
    // Texture format testing for Metal backend
    // Stub implementation for now
}

} // namespace Diligent
