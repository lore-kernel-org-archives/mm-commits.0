From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Fri, 20 Apr 2012 11:47:49 -0700
Message-ID: <20120420184751.05A00A018B@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:54634 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755083Ab2DTSry (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Apr 2012 14:47:54 -0400
Received: by wgbdt11 with SMTP id dt11so532654wgb.1
        for <mm-commits@vger.kernel.org>; Fri, 20 Apr 2012 11:47:52 -0700 (PDT)
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

 sound/pci/hda/patch_conexant.c |   17 -----------------
 1 file changed, 17 deletions(-)

diff -puN sound/pci/hda/patch_conexant.c~linux-next-git-rejects sound/pci/hda/patch_conexant.c
--- a/sound/pci/hda/patch_conexant.c~linux-next-git-rejects
+++ a/sound/pci/hda/patch_conexant.c
@@ -4461,14 +4461,11 @@ static void apply_fixup(struct hda_codec
 	}
 }
 
-<<<<<<< HEAD
 enum {
 	CXT_PINCFG_LENOVO_X200,
 	CXT_PINCFG_LENOVO_TP410,
 };
 
-=======
->>>>>>> linux-next/akpm-end
 /* ThinkPad X200 & co with cxt5051 */
 static const struct cxt_pincfg cxt_pincfg_lenovo_x200[] = {
 	{ 0x16, 0x042140ff }, /* HP (seq# overridden) */
@@ -4489,10 +4486,7 @@ static const struct cxt_pincfg cxt_pincf
 static const struct cxt_pincfg *cxt_pincfg_tbl[] = {
 	[CXT_PINCFG_LENOVO_X200] = cxt_pincfg_lenovo_x200,
 	[CXT_PINCFG_LENOVO_TP410] = cxt_pincfg_lenovo_tp410,
-<<<<<<< HEAD
-=======
 	[CXT_FIXUP_STEREO_DMIC] = NULL,
->>>>>>> linux-next/akpm-end
 };
 
 static const struct snd_pci_quirk cxt5051_fixups[] = {
@@ -4506,10 +4500,7 @@ static const struct snd_pci_quirk cxt506
 	SND_PCI_QUIRK(0x17aa, 0x215f, "Lenovo T510", CXT_PINCFG_LENOVO_TP410),
 	SND_PCI_QUIRK(0x17aa, 0x21ce, "Lenovo T420", CXT_PINCFG_LENOVO_TP410),
 	SND_PCI_QUIRK(0x17aa, 0x21cf, "Lenovo T520", CXT_PINCFG_LENOVO_TP410),
-<<<<<<< HEAD
-=======
 	SND_PCI_QUIRK(0x17aa, 0x3975, "Lenovo U300s", CXT_FIXUP_STEREO_DMIC),
->>>>>>> linux-next/akpm-end
 	{}
 };
 
@@ -4549,19 +4540,11 @@ static int patch_conexant_auto(struct hd
 	case 0x14f15051:
 		add_cx5051_fake_mutes(codec);
 		codec->pin_amp_workaround = 1;
-<<<<<<< HEAD
-		apply_pin_fixup(codec, cxt5051_fixups, cxt_pincfg_tbl);
-		break;
-	default:
-		codec->pin_amp_workaround = 1;
-		apply_pin_fixup(codec, cxt5066_fixups, cxt_pincfg_tbl);
-=======
 		apply_fixup(codec, cxt5051_fixups, cxt_pincfg_tbl);
 		break;
 	default:
 		codec->pin_amp_workaround = 1;
 		apply_fixup(codec, cxt5066_fixups, cxt_pincfg_tbl);
->>>>>>> linux-next/akpm-end
 	}
 
 	/* Show mute-led control only on HP laptops
_
Subject: Subject: linux-next-git-rejects

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-block-nvmec-stop-breaking-my-i386-build.patch
drivers-staging-zsmalloc-zsmalloc-mainc-unbork.patch
mm-correctly-synchronize-rss-counters-at-exit-exec-fix.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
arch-x86-kernel-apic-io_apicc-move-io_apic_level_ack_pending-inside-config_generic_pending_irq.patch
drivers-xen-kconfig-fix-kconfig-layout.patch
x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs.patch
x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs-fix.patch
percpu-remove-percpu_xxx-functions-fix.patch
fs-symlink-restrictions-on-sticky-directories.patch
fs-hardlink-creation-restrictions.patch
brlocks-lglocks-cleanups.patch
mm.patch
hugetlbfs-add-memcg-control-files-for-hugetlbfs-use-scnprintf-instead-of-sprintf-fix.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
mm-push-lru-index-into-shrink_active_list-fix.patch
security-keys-keyctlc-suppress-memory-allocation-failure-warning.patch
spinlockstxt-add-a-discussion-on-why-spin_is_locked-is-bad-fix.patch
vsprintf-correctly-handle-width-when-flag-used-in-%p-format-checkpatch-fixes.patch
vsprintf-further-optimize-decimal-conversion-checkpatch-fixes.patch
leds-led-module-for-da9052-53-pmic-v2-fix.patch
leds-add-led-driver-for-lm3556-chip-checkpatch-fixes.patch
leds-ledtrig-timer-trigger_data-allocation-fix-fix.patch
lib-string_helpersc-make-arrays-static.patch
rtc-rename-config_rtc_mxc-to-config_rtc_drv_mxc-fix.patch
kmod-avoid-deadlock-by-recursive-kmod-call.patch
proc-clean-up-proc-pid-environ-handling-checkpatch-fixes.patch
eventfd-change-int-to-__u64-in-eventfd_signal-fix.patch
syscalls-x86-add-__nr_kcmp-syscall-v8.patch
syscalls-x86-add-__nr_kcmp-syscall-v8-comment-update-fix.patch
c-r-prctl-add-ability-to-get-clear_tid_address.patch
c-r-ipc-selftest-tor-new-msg_peek_all-flag-for-msgrcv-checkpatch-fixes.patch
notify_change-check-that-i_mutex-is-held.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

