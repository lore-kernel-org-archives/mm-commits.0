From: akpm@linux-foundation.org
Subject: [obsolete] drivers-gpu-drm-nouveau-fix-build.patch removed from
 -mm tree
Date: Thu, 21 Aug 2014 13:21:01 -0700
Message-ID: <53f654ad.86TMmF1gXwgbFuM+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qg0-f74.google.com ([209.85.192.74]:46583 "EHLO
	mail-qg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754015AbaHUUVD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Aug 2014 16:21:03 -0400
Received: by mail-qg0-f74.google.com with SMTP id a108so789447qge.5
        for <mm-commits@vger.kernel.org>; Thu, 21 Aug 2014 13:21:02 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bskeggs@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/gpu/drm/nouveau: fix build
has been removed from the -mm tree.  Its filename was
     drivers-gpu-drm-nouveau-fix-build.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: drivers/gpu/drm/nouveau: fix build

wtf

Cc: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/nouveau/core/include/nvif/class.h  |    2 +-
 drivers/gpu/drm/nouveau/core/include/nvif/event.h  |    2 +-
 drivers/gpu/drm/nouveau/core/include/nvif/ioctl.h  |    2 +-
 drivers/gpu/drm/nouveau/core/include/nvif/unpack.h |    2 +-
 drivers/gpu/drm/nouveau/nvif/os.h                  |    2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/gpu/drm/nouveau/core/include/nvif/unpack.h~drivers-gpu-drm-nouveau-fix-build drivers/gpu/drm/nouveau/core/include/nvif/unpack.h
--- a/drivers/gpu/drm/nouveau/core/include/nvif/unpack.h~drivers-gpu-drm-nouveau-fix-build
+++ a/drivers/gpu/drm/nouveau/core/include/nvif/unpack.h
@@ -1 +1 @@
-../../../nvif/unpack.h
\ No newline at end of file
+#include "../../../nvif/unpack.h"
diff -puN drivers/gpu/drm/nouveau/core/include/nvif/event.h~drivers-gpu-drm-nouveau-fix-build drivers/gpu/drm/nouveau/core/include/nvif/event.h
--- a/drivers/gpu/drm/nouveau/core/include/nvif/event.h~drivers-gpu-drm-nouveau-fix-build
+++ a/drivers/gpu/drm/nouveau/core/include/nvif/event.h
@@ -1 +1 @@
-../../../nvif/event.h
\ No newline at end of file
+#include "../../../nvif/event.h"
diff -puN drivers/gpu/drm/nouveau/core/include/nvif/ioctl.h~drivers-gpu-drm-nouveau-fix-build drivers/gpu/drm/nouveau/core/include/nvif/ioctl.h
--- a/drivers/gpu/drm/nouveau/core/include/nvif/ioctl.h~drivers-gpu-drm-nouveau-fix-build
+++ a/drivers/gpu/drm/nouveau/core/include/nvif/ioctl.h
@@ -1 +1 @@
-../../../nvif/ioctl.h
\ No newline at end of file
+#include "../../../nvif/ioctl.h"
diff -puN drivers/gpu/drm/nouveau/core/include/nvif/class.h~drivers-gpu-drm-nouveau-fix-build drivers/gpu/drm/nouveau/core/include/nvif/class.h
--- a/drivers/gpu/drm/nouveau/core/include/nvif/class.h~drivers-gpu-drm-nouveau-fix-build
+++ a/drivers/gpu/drm/nouveau/core/include/nvif/class.h
@@ -1 +1 @@
-../../../nvif/class.h
\ No newline at end of file
+#include "../../../nvif/class.h"
diff -puN drivers/gpu/drm/nouveau/nvif/os.h~drivers-gpu-drm-nouveau-fix-build drivers/gpu/drm/nouveau/nvif/os.h
--- a/drivers/gpu/drm/nouveau/nvif/os.h~drivers-gpu-drm-nouveau-fix-build
+++ a/drivers/gpu/drm/nouveau/nvif/os.h
@@ -1 +1 @@
-../core/os.h
\ No newline at end of file
+#include "../core/os.h"
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
maintainers-akpm-maintenance.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
o2dlm-fix-null-pointer-dereference-in-o2dlm_blocking_ast_wrapper-checkpatch-fixes.patch
ocfs2-free-inode-when-i_count-becomes-zero.patch
mm.patch
memory-hotplug-add-sysfs-zones_online_to-attribute-fix.patch
memory-hotplug-add-sysfs-zones_online_to-attribute-fix-2.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
fs-proc-task_mmuc-shift-mm_access-from-m_start-to-proc_maps_open-checkpatch-fixes.patch
fs-proc-task_mmuc-simplify-the-vma_stop-logic-checkpatch-fixes.patch
fs-proc-task_nommuc-shift-mm_access-from-m_start-to-proc_maps_open-checkpatch-fixes.patch
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

