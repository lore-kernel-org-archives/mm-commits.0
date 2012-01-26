From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Thu, 26 Jan 2012 15:01:57 -0800
Message-ID: <20120126230159.ACC44A02A8@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qy0-f202.google.com ([209.85.216.202]:54019 "EHLO
	mail-qy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754175Ab2AZXCB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 26 Jan 2012 18:02:01 -0500
Received: by qcsd17 with SMTP id d17so122856qcs.1
        for <mm-commits@vger.kernel.org>; Thu, 26 Jan 2012 15:02:00 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

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
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68k/kernel/process_mm.c |    4 ----
 sound/soc/codecs/wm5100.c     |   28 ----------------------------
 2 files changed, 32 deletions(-)

diff -puN arch/m68k/kernel/process_mm.c~linux-next-git-rejects arch/m68k/kernel/process_mm.c
--- a/arch/m68k/kernel/process_mm.c~linux-next-git-rejects
+++ a/arch/m68k/kernel/process_mm.c
@@ -172,11 +172,7 @@ void flush_thread(void)
 
 	current->thread.fs = __USER_DS;
 	if (!FPU_IS_EMU)
-<<<<<<< HEAD
 		asm volatile("frestore %0": :"m" (zero));
-=======
-		asm volatile ("frestore %0" : : "m" (zero));
->>>>>>> linux-next/akpm-end
 }
 
 /*
diff -puN sound/soc/codecs/wm5100.c~linux-next-git-rejects sound/soc/codecs/wm5100.c
--- a/sound/soc/codecs/wm5100.c~linux-next-git-rejects
+++ a/sound/soc/codecs/wm5100.c
@@ -1373,34 +1373,6 @@ static int wm5100_set_bias_level(struct 
 			}
 
 			regcache_cache_only(wm5100->regmap, false);
-<<<<<<< HEAD
-
-			switch (wm5100->rev) {
-			case 0:
-				regcache_cache_bypass(wm5100->regmap, true);
-				snd_soc_write(codec, 0x11, 0x3);
-				snd_soc_write(codec, 0x203, 0xc);
-				snd_soc_write(codec, 0x206, 0);
-				snd_soc_write(codec, 0x207, 0xf0);
-				snd_soc_write(codec, 0x208, 0x3c);
-				snd_soc_write(codec, 0x209, 0);
-				snd_soc_write(codec, 0x211, 0x20d8);
-				snd_soc_write(codec, 0x11, 0);
-
-				for (i = 0;
-				     i < ARRAY_SIZE(wm5100_reva_patches);
-				     i++)
-					snd_soc_write(codec,
-						      wm5100_reva_patches[i].reg,
-						      wm5100_reva_patches[i].val);
-				regcache_cache_bypass(wm5100->regmap, false);
-				break;
-			default:
-				break;
-			}
-
-=======
->>>>>>> linux-next/akpm-end
 			regcache_sync(wm5100->regmap);
 		}
 		break;
_
Subject: Subject: linux-next-git-rejects

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
mm-memcontrolc-fix-warning-with-config_numa=n.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
x86-olpc-xo15-sci-enable-lid-close-wakeup-control-through-sysfs.patch
drivers-platform-x86-sony-laptopc-fix-scancodes.patch
fs-btrfs-inode-mapc-fix-warnings.patch
x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs-fix.patch
thermal-thermal_sys-fix-build-warning-fix.patch
drivers-scsi-mpt2sas-mpt2sas_scsihc-spell-primitive-correctly.patch
mm.patch
make-swapin-readahead-skip-over-holes-fix.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
memcg-remove-pcg_cache-page_cgroup-flag-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix-fix.patch
prctl-add-pr_setget_child_subreaper-to-allow-simple-process-supervision-fix-fix-fix.patch
kernel-exitc-if-init-dies-log-a-signal-which-killed-it-if-any-fix.patch
brlocks-lglocks-cleanups-checkpatch-fixes.patch
crc32-move-long-comment-about-crc32-fundamentals-to-documentation-fix.patch
kmod-avoid-deadlock-by-recursive-kmod-call-fix.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
linux-next-git-rejects.patch

