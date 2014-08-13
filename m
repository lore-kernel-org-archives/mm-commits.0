From: akpm@linux-foundation.org
Subject: +
 drivers-gpu-drm-nouveau-core-include-nvif-unpackh-fix-build.patch added to
 -mm tree
Date: Wed, 13 Aug 2014 12:17:50 -0700
Message-ID: <53ebb9de.YZT5Lfn2d33kw7Gd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oa0-f74.google.com ([209.85.219.74]:62480 "EHLO
	mail-oa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975AbaHMTRv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Aug 2014 15:17:51 -0400
Received: by mail-oa0-f74.google.com with SMTP id eb12so52083oac.1
        for <mm-commits@vger.kernel.org>; Wed, 13 Aug 2014 12:17:50 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bskeggs@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/gpu/drm/nouveau/core/include/nvif/unpack.h: fix build
has been added to the -mm tree.  Its filename is
     drivers-gpu-drm-nouveau-core-include-nvif-unpackh-fix-build.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-gpu-drm-nouveau-core-include-nvif-unpackh-fix-build.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-gpu-drm-nouveau-core-include-nvif-unpackh-fix-build.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: drivers/gpu/drm/nouveau/core/include/nvif/unpack.h: fix build

wtf

Cc: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/nouveau/core/include/nvif/unpack.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/gpu/drm/nouveau/core/include/nvif/unpack.h~drivers-gpu-drm-nouveau-core-include-nvif-unpackh-fix-build drivers/gpu/drm/nouveau/core/include/nvif/unpack.h
--- a/drivers/gpu/drm/nouveau/core/include/nvif/unpack.h~drivers-gpu-drm-nouveau-core-include-nvif-unpackh-fix-build
+++ a/drivers/gpu/drm/nouveau/core/include/nvif/unpack.h
@@ -1 +1 @@
-../../../nvif/unpack.h
+#include ../../../nvif/unpack.h
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
maintainers-akpm-maintenance.patch
drivers-gpu-drm-nouveau-core-include-nvif-unpackh-fix-build.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
o2dlm-fix-null-pointer-dereference-in-o2dlm_blocking_ast_wrapper-checkpatch-fixes.patch
ocfs2-free-inode-when-i_count-becomes-zero.patch
mm.patch
mm-hugetlb-remove-unused-argument-of-follow_huge_pmdpud.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
linux-next.patch
drivers-gpio-gpio-zevioc-fix-build.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

