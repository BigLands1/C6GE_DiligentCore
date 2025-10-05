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
#include "ShaderMtlImpl.hpp"
#import <Metal/Metal.h>

namespace Diligent
{

PipelineStateMtlImpl::PipelineStateMtlImpl(IReferenceCounters*             pRefCounters,
                                           RenderDeviceMtlImpl*            pRenderDeviceMtl,
                                           const PipelineStateCreateInfo&  CreateInfo,
                                           bool                            IsDeviceInternal) :
    TPipelineStateBase{pRefCounters, pRenderDeviceMtl, CreateInfo, IsDeviceInternal}
{
    @autoreleasepool
    {
        id<MTLDevice> mtlDevice = pRenderDeviceMtl->GetMtlDevice();
        
        if (CreateInfo.PSODesc.PipelineType == PIPELINE_TYPE_GRAPHICS || 
            CreateInfo.PSODesc.PipelineType == PIPELINE_TYPE_MESH)
        {
            // Create graphics pipeline state
            auto& GraphicsPipeline = CreateInfo.PSODesc.GraphicsPipeline;
            
            MTLRenderPipelineDescriptor* pipelineDesc = [[MTLRenderPipelineDescriptor alloc] init];
            
            // Set up vertex function
            if (GraphicsPipeline.pVS != nullptr)
            {
                auto* pVS = static_cast<ShaderMtlImpl*>(GraphicsPipeline.pVS);
                NSString* entryPoint = [NSString stringWithUTF8String:pVS->GetEntryPoint().c_str()];
                id<MTLFunction> vertexFunc = [pVS->GetMtlLibrary() newFunctionWithName:entryPoint];
                if (vertexFunc != nil)
                {
                    pipelineDesc.vertexFunction = vertexFunc;
                    [vertexFunc release];
                }
            }
            
            // Set up fragment function
            if (GraphicsPipeline.pPS != nullptr)
            {
                auto* pPS = static_cast<ShaderMtlImpl*>(GraphicsPipeline.pPS);
                NSString* entryPoint = [NSString stringWithUTF8String:pPS->GetEntryPoint().c_str()];
                id<MTLFunction> fragmentFunc = [pPS->GetMtlLibrary() newFunctionWithName:entryPoint];
                if (fragmentFunc != nil)
                {
                    pipelineDesc.fragmentFunction = fragmentFunc;
                    [fragmentFunc release];
                }
            }
            
            NSError* error = nil;
            m_MtlRenderPipeline = [mtlDevice newRenderPipelineStateWithDescriptor:pipelineDesc error:&error];
            [pipelineDesc release];
            
            if (m_MtlRenderPipeline == nil || error != nil)
            {
                if (error != nil)
                {
                    NSString* errorMsg = [error localizedDescription];
                    LOG_ERROR_MESSAGE("Failed to create Metal render pipeline state: ", [errorMsg UTF8String]);
                }
            }
            
            // Create depth stencil state if needed
            if (GraphicsPipeline.DepthStencilDesc.DepthEnable || GraphicsPipeline.DepthStencilDesc.StencilEnable)
            {
                MTLDepthStencilDescriptor* dsDesc = [[MTLDepthStencilDescriptor alloc] init];
                dsDesc.depthCompareFunction = GraphicsPipeline.DepthStencilDesc.DepthEnable ? MTLCompareFunctionLess : MTLCompareFunctionAlways;
                dsDesc.depthWriteEnabled = GraphicsPipeline.DepthStencilDesc.DepthWriteEnable ? YES : NO;
                
                m_MtlDepthStencilState = [mtlDevice newDepthStencilStateWithDescriptor:dsDesc];
                [dsDesc release];
            }
        }
        else if (CreateInfo.PSODesc.PipelineType == PIPELINE_TYPE_COMPUTE)
        {
            // Create compute pipeline state
            auto& ComputePipeline = CreateInfo.PSODesc.ComputePipeline;
            
            if (ComputePipeline.pCS != nullptr)
            {
                auto* pCS = static_cast<ShaderMtlImpl*>(ComputePipeline.pCS);
                NSString* entryPoint = [NSString stringWithUTF8String:pCS->GetEntryPoint().c_str()];
                id<MTLFunction> computeFunc = [pCS->GetMtlLibrary() newFunctionWithName:entryPoint];
                
                if (computeFunc != nil)
                {
                    NSError* error = nil;
                    m_MtlComputePipeline = [mtlDevice newComputePipelineStateWithFunction:computeFunc error:&error];
                    [computeFunc release];
                    
                    if (m_MtlComputePipeline == nil || error != nil)
                    {
                        if (error != nil)
                        {
                            NSString* errorMsg = [error localizedDescription];
                            LOG_ERROR_MESSAGE("Failed to create Metal compute pipeline state: ", [errorMsg UTF8String]);
                        }
                    }
                }
            }
        }
    }
}

PipelineStateMtlImpl::~PipelineStateMtlImpl()
{
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
