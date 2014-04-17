From: akpm@linux-foundation.org
Subject: +
 drm-nouveau-bios-fix-a-bit-shift-error-introduced-by-457e77b-fix.patch
 added to -mm tree
Date: Thu, 17 Apr 2014 12:33:42 -0700
Message-ID: <53502c96.4/n3EhxFC+ATXrcS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59714 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110AbaDQTdn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Apr 2014 15:33:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, saproj@gmail.com, bskeggs@redhat.com, airlied@redhat.com, akpm@linux-foundation.org

Subject: + drm-nouveau-bios-fix-a-bit-shift-error-introduced-by-457e77b-fix.patch added to -mm tree
To: akpm@linux-foundation.org,airlied@redhat.com,bskeggs@redhat.com,saproj@gmail.com
From: akpm@linux-foundation.org
Date: Thu, 17 Apr 2014 12:33:42 -0700


The patch titled
     Subject: drm-nouveau-bios-fix-a-bit-shift-error-introduced-by-457e77b-fix
has been added to the -mm tree.  Its filename is
     drm-nouveau-bios-fix-a-bit-shift-error-introduced-by-457e77b-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drm-nouveau-bios-fix-a-bit-shift-error-introduced-by-457e77b-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drm-nouveau-bios-fix-a-bit-shift-error-introduced-by-457e77b-fix.patch

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
Subject: drm-nouveau-bios-fix-a-bit-shift-error-introduced-by-457e77b-fix

remove cast, per Sergei

Cc: Ben Skeggs <bskeggs@redhat.com>
Cc: Dave Airlie <airlied@redhat.com>
Cc: Sergei Antonov <saproj@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpu/drm/nouveau/core/subdev/bios/base.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/gpu/drm/nouveau/core/subdev/bios/base.c~drm-nouveau-bios-fix-a-bit-shift-error-introduced-by-457e77b-fix drivers/gpu/drm/nouveau/core/subdev/bios/base.c
--- a/drivers/gpu/drm/nouveau/core/subdev/bios/base.c~drm-nouveau-bios-fix-a-bit-shift-error-introduced-by-457e77b-fix
+++ a/drivers/gpu/drm/nouveau/core/subdev/bios/base.c
@@ -109,7 +109,7 @@ nouveau_bios_shadow_pramin(struct nouvea
 			return;
 		}
 
-		addr = (u64)(addr & 0xffffff00) << 8;
+		addr = (addr & 0xffffff00) << 8;
 		if (!addr) {
 			addr  = (u64)nv_rd32(bios, 0x001700) << 16;
 			addr += 0xf0000;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
maintainers-akpm-maintenance.patch
kernel-watchdogc-touch_softlockup_watchdog-use-raw_cpu_write.patch
wait-explain-the-shadowing-and-type-inconsistencies.patch
mips-export-flush_icache_range-fix.patch
drm-nouveau-bios-fix-a-bit-shift-error-introduced-by-457e77b-fix.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
ocfs2-do-not-return-dlm_migrate_response_mastery_ref-to-avoid-endlessloop-during-umount.patch
mm.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3-fix.patch
pagewalk-update-page-table-walker-core-fix-end-address-calculation-in-walk_page_range-fix.patch
pagemap-redefine-callback-functions-for-page-table-walker-fix.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry-fix-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
mm-huge_memoryc-complete-conversion-to-pr_foo.patch
include-linux-mmdebugh-add-vm_warn_on-and-vm_warn_on_once.patch
mm-mempool-warn-about-__gfp_zero-usage-fix.patch
mm-pass-vm_bug_on-reason-to-dump_page-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
init-mainc-dont-use-pr_debug.patch
init-mainc-add-initcall_blacklist-kernel-parameter-fix.patch
linux-next.patch
drivers-gpio-gpio-zevioc-fix-build.patch
ufs-sb-mutex-merge-mutex_destroy.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

