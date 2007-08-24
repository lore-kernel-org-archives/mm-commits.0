From: akpm@linux-foundation.org
Subject: + codingstyle-relax-the-80-cole-rule.patch added to -mm tree
Date: Fri, 24 Aug 2007 16:26:49 -0700
Message-ID: <200708242326.l7ONQn2e020122@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58047 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932430AbXHXX1e (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2007 19:27:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk, alan@redhat.com


The patch titled
     CodingStyle: relax the 80-cole rule
has been added to the -mm tree.  Its filename is
     codingstyle-relax-the-80-cole-rule.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: CodingStyle: relax the 80-cole rule
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

I would suggest this change to make CodingStyle properly reflect the style
used by the kernel, rather than the current wording which is wishful
thinking and misleading, and comes from the same school of thought that
gets off on prescriptive grammar, latin and comp.std.c

Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/CodingStyle |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff -puN Documentation/CodingStyle~codingstyle-relax-the-80-cole-rule Documentation/CodingStyle
--- a/Documentation/CodingStyle~codingstyle-relax-the-80-cole-rule
+++ a/Documentation/CodingStyle
@@ -77,12 +77,15 @@ Get a decent editor and don't leave whit
 Coding style is all about readability and maintainability using commonly
 available tools.
 
-The limit on the length of lines is 80 columns and this is a hard limit.
+The limit on the length of lines is 80 columns and this is a strongly
+preferred limit.
 
 Statements longer than 80 columns will be broken into sensible chunks.
 Descendants are always substantially shorter than the parent and are placed
 substantially to the right. The same applies to function headers with a long
-argument list. Long strings are as well broken into shorter strings.
+argument list. Long strings are as well broken into shorter strings. The 
+only exception to this is where exceeding 80 columns significantly increases
+readability and does not hide information.
 
 void fun(int a, int b, int c)
 {
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
git-libata-all.patch
pata_acpi-rework-the-acpi-drivers-based-upon-experience.patch
libata-switch-most-of-the-remaining-sff-drivers-to.patch
pata_marvell-add-more-identifiers.patch
libata-portmap-remove-unused-definitions.patch
libata-correct-handling-of-srst-reset-sequences.patch
libata-spot-bridge-chips.patch
libata-allow-for-original-ide-drives-that-dont-support-geometry-setting.patch
libata-strict-checking-for-identify-reporting.patch
libata-add-a-drivers-ide-style-dma-disable.patch
drivers-ata-ioremap-returncode-check-pata_ixp4xx_cfc.patch
st340823a-hpa-and-libata.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
tty-add-the-new-ioctls-and-definitionto-the-mips.patch
serial_txx9-cleanup-includes.patch
serial-keep-the-dtr-setting-for-serial-console.patch
8250_pci-autodetect-mainpine-cards.patch
fix-ide-legacy-mode-resources.patch
fix-ide-legacy-mode-resources-fix.patch
git-scsi-misc.patch
fix-gregkh-usb-usb-serial-fix-oti6858c-segfault-in-termios-handling.patch
kobil_sct-rework-driver.patch
geode-mfgpt-support-for-geode-class-machines.patch
geode-mfgpt-clock-event-device-support.patch
xtensa-enable-arbitary-tty-speed-setting-ioctls.patch
security-convert-lsm-into-a-static-interface-vs-fix-null-pointer-dereference-in-__vm_enough_memory.patch
blackfin-enable-arbitary-speed-serial-setting.patch
mxser-remove-use-of-dead-tty_flipbuf_size-definition.patch
jsm-remove-further-unneeded-crud.patch
ttyh-remove-dead-define.patch
codingstyle-relax-the-80-cole-rule.patch
sysctl-remove-broken-cdrom-binary-sysctls.patch
mxser-remove-commented-crap.patch
char-cyclades-remove-bottom-half-processing.patch
