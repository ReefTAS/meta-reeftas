# ex:ts=4:sw=4:sts=4:et
# -*- tab-width: 4; c-basic-offset: 4; indent-tabs-mode: nil -*-
#
#

import logging
import os
import shutil

from oe.path import copyhardlinktree

from wic import WicError
from wic.pluginbase import SourcePlugin
from wic.pluginbase import PluginMgr

from wic.utils.misc import get_bitbake_var, exec_cmd

logger = logging.getLogger('reeftas-rootfs')

class ReeftasRootfsPlugin(SourcePlugin):
    """
    Populate partition content from a rootfs directory.
    """
    
    name = 'reeftas-rootfs'

    @classmethod
    def do_prepare_partition(cls, part, source_params, cr, cr_workdir,
                             oe_builddir, bootimg_dir, kernel_dir,
                             krootfs_dir, native_sysroot):

        if 'fstype-varname' in source_params and \
                            source_params['fstype-varname'].split():
            part.fstype = get_bitbake_var(source_params['fstype-varname'])

        if 'align-varname' in source_params and \
                            source_params['align-varname'].split():
            part.align = int(get_bitbake_var(source_params['align-varname']))

        if 'size-varname' in source_params and \
                            source_params['size-varname'].split():
            part.fixed_size = int(get_bitbake_var(source_params['size-varname']))

        if 'mountpoint-varname' in source_params and \
                                source_params['mountpoint-varname'].split():
            part.mountpoint = get_bitbake_var(source_params['mountpoint-varname'])

        plugin = PluginMgr.get_plugins('source')['rootfs']        
        plugin.do_prepare_partition(part, source_params,
                                    cr, cr_workdir, oe_builddir, 
                                    bootimg_dir, kernel_dir, krootfs_dir,
                                    native_sysroot)
