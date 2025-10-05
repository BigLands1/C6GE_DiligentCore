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

#include "ShaderMtlImpl.hpp"
#include "RenderDeviceMtlImpl.hpp"
#import <Metal/Metal.h>

namespace Diligent
{

ShaderMtlImpl::ShaderMtlImpl(IReferenceCounters*     pRefCounters,
                             RenderDeviceMtlImpl*    pRenderDeviceMtl,
                             const ShaderCreateInfo& ShaderCI,
                             const CreateInfo&       MtlShaderCI,
                             bool                    IsDeviceInternal) :
    TShaderBase{pRefCounters, pRenderDeviceMtl, ShaderCI.Desc, MtlShaderCI, IsDeviceInternal}
{
    // Store entry point
    if (ShaderCI.EntryPoint != nullptr && ShaderCI.EntryPoint[0] != '\0')
    {
        m_EntryPoint = ShaderCI.EntryPoint;
    }

    // Compile MSL shader from source
    if (ShaderCI.Source != nullptr && ShaderCI.SourceLength > 0)
    {
        @autoreleasepool
        {
            id<MTLDevice> mtlDevice = pRenderDeviceMtl->GetMtlDevice();
            
            NSString* source = [[NSString alloc] initWithBytes:ShaderCI.Source
                                                        length:ShaderCI.SourceLength
                                                      encoding:NSUTF8StringEncoding];
            
            NSError* error = nil;
            id<MTLLibrary> library = [mtlDevice newLibraryWithSource:source
                                                             options:nil
                                                               error:&error];
            [source release];
            
            if (library == nil || error != nil)
            {
                if (error != nil)
                {
                    NSString* errorMsg = [error localizedDescription];
                    LOG_ERROR_MESSAGE("Failed to compile Metal shader '", ShaderCI.Desc.Name, "': ", [errorMsg UTF8String]);
                }
                else
                {
                    LOG_ERROR_MESSAGE("Failed to compile Metal shader '", ShaderCI.Desc.Name, "'");
                }
                
                if (MtlShaderCI.ppCompilerOutput != nullptr)
                {
                    // TODO: Create data blob with error message
                }
            }
            else
            {
                // Store the compiled library
                m_MtlLibrary = library;
            }
        }
    }
}

ShaderMtlImpl::~ShaderMtlImpl()
{
    if (m_MtlLibrary != nil)
    {
        [m_MtlLibrary release];
        m_MtlLibrary = nil;
    }
}

void ShaderMtlImpl::QueryInterface(const INTERFACE_ID& IID, IObject** ppInterface)
{
    if (ppInterface == nullptr)
        return;

    *ppInterface = nullptr;
    if (IID == IID_ShaderMtl || IID == IID_InternalImpl)
    {
        *ppInterface = this;
        (*ppInterface)->AddRef();
    }
    else
    {
        TShaderBase::QueryInterface(IID, ppInterface);
    }
}

} // namespace Diligent
