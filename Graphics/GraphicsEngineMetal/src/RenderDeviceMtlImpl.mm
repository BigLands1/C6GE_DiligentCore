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
    // TODO: Initialize Metal device
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
    // TODO: Implement graphics pipeline state creation
    LOG_ERROR_MESSAGE("CreateGraphicsPipelineState is not yet implemented for Metal backend");
}

void RenderDeviceMtlImpl::CreateComputePipelineState(const ComputePipelineStateCreateInfo& PSOCreateInfo,
                                                     IPipelineState**                      ppPipelineState)
{
    // TODO: Implement compute pipeline state creation
    LOG_ERROR_MESSAGE("CreateComputePipelineState is not yet implemented for Metal backend");
}

void RenderDeviceMtlImpl::CreateBuffer(const BufferDesc& BuffDesc,
                                       const BufferData* pBuffData,
                                       IBuffer**         ppBuffer)
{
    // TODO: Implement buffer creation
    LOG_ERROR_MESSAGE("CreateBuffer is not yet implemented for Metal backend");
}

void RenderDeviceMtlImpl::CreateShader(const ShaderCreateInfo& ShaderCreateInfo,
                                       IShader**               ppShader,
                                       IDataBlob**             ppCompilerOutput)
{
    // TODO: Implement shader creation
    LOG_ERROR_MESSAGE("CreateShader is not yet implemented for Metal backend");
}

void RenderDeviceMtlImpl::CreateTexture(const TextureDesc& TexDesc,
                                        const TextureData* pData,
                                        ITexture**         ppTexture)
{
    // TODO: Implement texture creation
    LOG_ERROR_MESSAGE("CreateTexture is not yet implemented for Metal backend");
}

void RenderDeviceMtlImpl::CreateSampler(const SamplerDesc& SamplerDesc,
                                        ISampler**         ppSampler)
{
    // TODO: Implement sampler creation
    LOG_ERROR_MESSAGE("CreateSampler is not yet implemented for Metal backend");
}

void RenderDeviceMtlImpl::CreateFence(const FenceDesc& Desc,
                                      IFence**         ppFence)
{
    // TODO: Implement fence creation
    LOG_ERROR_MESSAGE("CreateFence is not yet implemented for Metal backend");
}

void RenderDeviceMtlImpl::CreateQuery(const QueryDesc& Desc,
                                      IQuery**         ppQuery)
{
    // TODO: Implement query creation
    LOG_ERROR_MESSAGE("CreateQuery is not yet implemented for Metal backend");
}

id<MTLDevice> RenderDeviceMtlImpl::GetMtlDevice() const
{
    return m_MtlDevice;
}

void RenderDeviceMtlImpl::CreateTextureFromMtlResource(id<MTLTexture>     mtlTexture,
                                                       const TextureDesc& TexDesc,
                                                       RESOURCE_STATE     InitialState,
                                                       ITexture**         ppTexture)
{
    // TODO: Implement texture creation from Metal resource
    LOG_ERROR_MESSAGE("CreateTextureFromMtlResource is not yet implemented for Metal backend");
}

void RenderDeviceMtlImpl::CreateBufferFromMtlResource(id<MTLBuffer>     mtlBuffer,
                                                      const BufferDesc& BuffDesc,
                                                      RESOURCE_STATE    InitialState,
                                                      IBuffer**         ppBuffer)
{
    // TODO: Implement buffer creation from Metal resource
    LOG_ERROR_MESSAGE("CreateBufferFromMtlResource is not yet implemented for Metal backend");
}

void RenderDeviceMtlImpl::CreateSparseTexture(const TextureDesc& TexDesc,
                                              IDeviceMemory*     pMemory,
                                              ITexture**         ppTexture)
{
    // TODO: Implement sparse texture creation
    LOG_ERROR_MESSAGE("CreateSparseTexture is not yet implemented for Metal backend");
}

} // namespace Diligent
