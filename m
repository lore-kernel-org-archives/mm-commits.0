From: akpm@linux-foundation.org
Subject: + kconfig-correct-minor-typo-in-kconfig-warning-message.patch added to -mm tree
Date: Wed, 02 May 2007 21:01:00 -0700
Message-ID: <200705030401.l43410hJ004386@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:58406 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767349AbXECEBG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 May 2007 00:01:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@mindspring.com, sam@ravnborg.org


The patch titled
     KCONFIG: correct minor typo in Kconfig warning message
has been added to the -mm tree.  Its filename is
     kconfig-correct-minor-typo-in-kconfig-warning-message.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: KCONFIG: correct minor typo in Kconfig warning message
From: "Robert P. J. Day" <rpjday@mindspring.com>

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/kconfig/menu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/kconfig/menu.c~kconfig-correct-minor-typo-in-kconfig-warning-message scripts/kconfig/menu.c
--- a/scripts/kconfig/menu.c~kconfig-correct-minor-typo-in-kconfig-warning-message
+++ a/scripts/kconfig/menu.c
@@ -203,7 +203,7 @@ void sym_check_prop(struct symbol *sym)
 			else if (sym2->type == S_UNKNOWN)
 				prop_warn(prop,
 				    "'select' used by config symbol '%s' "
-				    "refer to undefined symbol '%s'",
+				    "refers to undefined symbol '%s'",
 				    sym->name, sym2->name);
 			else if (sym2->type != S_BOOLEAN && sym2->type != S_TRISTATE)
 				prop_warn(prop,
_

Patches currently in -mm which might be from rpjday@mindspring.com are

origin.patch
arm26-remove-useless-config-option-generic_bust_spinlock.patch
remove-unused-header-file-arch-m68k-atari-atasoundh.patch
remove-unused-header-file-drivers-serial-crisv10h.patch
cris-remove-code-related-to-pre-22-kernel.patch
remove-unused-header-file-arch-um-kernel-tt-include-mode_kern-tth.patch
git-alsa.patch
remove-unused-header-file-arch-arm-mach-s3c2410-basth.patch
arm-remove-useless-config-option-generic_bust_spinlock.patch
git-avr32.patch
git-drm.patch
git-input.patch
kconfig-correct-minor-typo-in-kconfig-warning-message.patch
pcmcia-delete-obsolete-pcmcia_ioctl-feature.patch
git-scsi-misc.patch
scsi-fix-obvious-typo-spin_lock_irqrestore-in-gdthc.patch
reiserfs-correct-misspelled-reiserfs_proc_info-to.patch
kconfig-centralize-the-selection-of-semaphore-debugging.patch
rocket-remove-modversions-include.patch
remove-unused-header-file-drivers-message-i2o-i2o_lanh.patch
remove-unused-header-file-drivers-char-digih.patch
delete-unused-header-file-math-emu-extendedh.patch
delete-unused-header-file-linux-awe_voiceh.patch
add-spaces-on-either-side-of-case-operator.patch
clarify-the-creation-of-the-localversion_auto-string.patch
some-grammatical-fixups-and-additions-to-atomich-kernel-doc.patch
remove-unused-header-file-drivers-video-riva-nv4refh.patch
video-add-spaces-on-either-side-of-the-case-operator.patch
