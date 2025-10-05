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

#include "PipelineStateMtlImpl.hpp"
#include "RenderDeviceMtlImpl.hpp"

namespace Diligent
{

PipelineStateMtlImpl::PipelineStateMtlImpl(IReferenceCounters*             pRefCounters,
                                           RenderDeviceMtlImpl*            pRenderDeviceMtl,
                                           const PipelineStateCreateInfo&  CreateInfo,
                                           bool                            IsDeviceInternal) :
    TPipelineStateBase{pRefCounters, pRenderDeviceMtl, CreateInfo, IsDeviceInternal}
{
    // TODO: Implement pipeline state creation
}

PipelineStateMtlImpl::~PipelineStateMtlImpl()
{
    // TODO: Cleanup pipeline state resources
    if (m_MtlRenderPipeline != nil)
    {
        [m_MtlRenderPipeline release];
        m_MtlRenderPipeline = nil;
    }
    if (m_MtlComputePipeline != nil)
    {
        [m_MtlComputePipeline release];
        m_MtlComputePipeline = nil;
    }
    if (m_MtlDepthStencilState != nil)
    {
        [m_MtlDepthStencilState release];
        m_MtlDepthStencilState = nil;
    }
}

id<MTLRenderPipelineState> PipelineStateMtlImpl::GetMtlRenderPipeline() const
{
    return m_MtlRenderPipeline;
}

id<MTLComputePipelineState> PipelineStateMtlImpl::GetMtlComputePipeline() const
{
    return m_MtlComputePipeline;
}

id<MTLDepthStencilState> PipelineStateMtlImpl::GetMtlDepthStencilState() const
{
    return m_MtlDepthStencilState;
}

} // namespace Diligent
