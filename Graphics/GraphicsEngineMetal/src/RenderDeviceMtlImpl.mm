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

void RenderDeviceMtlImpl::CreateTextureFromMtlResource(id<MTLTexture>     mtlTexture,
                                                       const TextureDesc& TexDesc,
                                                       RESOURCE_STATE     InitialState,
                                                       ITexture**         ppTexture)
{
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
}

} // namespace Diligent
