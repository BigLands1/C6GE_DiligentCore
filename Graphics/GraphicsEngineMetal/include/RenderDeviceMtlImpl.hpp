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

#pragma once

/// \file
/// Declaration of Diligent::RenderDeviceMtlImpl class

#include "EngineMtlImplTraits.hpp"
#include "RenderDeviceBase.hpp"
#include "RenderDeviceNextGenBase.hpp"

#import <Metal/Metal.h>

namespace Diligent
{

/// Render device implementation in Metal backend.
class RenderDeviceMtlImpl final : public RenderDeviceNextGenBase<RenderDeviceBase<EngineMtlImplTraits>, ICommandQueueMtl>
{
public:
    using BaseInterface     = IRenderDeviceMtl;
    using TRenderDeviceBase = RenderDeviceNextGenBase<RenderDeviceBase<EngineMtlImplTraits>, ICommandQueueMtl>;

    RenderDeviceMtlImpl(IReferenceCounters*        pRefCounters,
                        IMemoryAllocator&          RawMemAllocator,
                        IEngineFactory*            pEngineFactory,
                        const EngineCreateInfo&    EngineCI,
                        const GraphicsAdapterInfo& AdapterInfo) noexcept(false);
    
    ~RenderDeviceMtlImpl();

    IMPLEMENT_QUERY_INTERFACE_IN_PLACE(IID_RenderDeviceMtl, TRenderDeviceBase)

    /// Implementation of IRenderDevice::CreateGraphicsPipelineState() in Metal backend.
    virtual void DILIGENT_CALL_TYPE CreateGraphicsPipelineState(const GraphicsPipelineStateCreateInfo& PSOCreateInfo,
                                                                IPipelineState**                       ppPipelineState) override final;

    /// Implementation of IRenderDevice::CreateComputePipelineState() in Metal backend.
    virtual void DILIGENT_CALL_TYPE CreateComputePipelineState(const ComputePipelineStateCreateInfo& PSOCreateInfo,
                                                               IPipelineState**                      ppPipelineState) override final;

    /// Implementation of IRenderDevice::CreateBuffer() in Metal backend.
    virtual void DILIGENT_CALL_TYPE CreateBuffer(const BufferDesc& BuffDesc,
                                                 const BufferData* pBuffData,
                                                 IBuffer**         ppBuffer) override final;

    /// Implementation of IRenderDevice::CreateShader() in Metal backend.
    virtual void DILIGENT_CALL_TYPE CreateShader(const ShaderCreateInfo& ShaderCreateInfo,
                                                 IShader**               ppShader,
                                                 IDataBlob**             ppCompilerOutput) override final;

    /// Implementation of IRenderDevice::CreateTexture() in Metal backend.
    virtual void DILIGENT_CALL_TYPE CreateTexture(const TextureDesc& TexDesc,
                                                  const TextureData* pData,
                                                  ITexture**         ppTexture) override final;

    /// Implementation of IRenderDevice::CreateSampler() in Metal backend.
    virtual void DILIGENT_CALL_TYPE CreateSampler(const SamplerDesc& SamplerDesc,
                                                  ISampler**         ppSampler) override final;

    /// Implementation of IRenderDevice::CreateFence() in Metal backend.
    virtual void DILIGENT_CALL_TYPE CreateFence(const FenceDesc& Desc,
                                                IFence**         ppFence) override final;

    /// Implementation of IRenderDevice::CreateQuery() in Metal backend.
    virtual void DILIGENT_CALL_TYPE CreateQuery(const QueryDesc& Desc,
                                                IQuery**         ppQuery) override final;

    /// Implementation of IRenderDeviceMtl::GetMtlDevice().
    virtual id<MTLDevice> DILIGENT_CALL_TYPE GetMtlDevice() const override final;

    /// Implementation of IRenderDeviceMtl::CreateTextureFromMtlResource().
    virtual void DILIGENT_CALL_TYPE CreateTextureFromMtlResource(id<MTLTexture>     mtlTexture,
                                                                 const TextureDesc& TexDesc,
                                                                 RESOURCE_STATE     InitialState,
                                                                 ITexture**         ppTexture) override final;

    /// Implementation of IRenderDeviceMtl::CreateBufferFromMtlResource().
    virtual void DILIGENT_CALL_TYPE CreateBufferFromMtlResource(id<MTLBuffer>        mtlBuffer,
                                                                const BufferDesc&    BuffDesc,
                                                                RESOURCE_STATE       InitialState,
                                                                IBuffer**            ppBuffer) override final;

    /// Implementation of IRenderDeviceMtl::CreateSparseTexture().
    virtual void DILIGENT_CALL_TYPE CreateSparseTexture(const TextureDesc& TexDesc,
                                                        IDeviceMemory*     pMemory,
                                                        ITexture**         ppTexture) override final;

private:
    id<MTLDevice> m_MtlDevice = nil;
};

} // namespace Diligent
