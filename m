From: akpm@linux-foundation.org
Subject: - remove-dubious-legal-statment-from-uio-howto.patch removed from -mm tree
Date: Thu, 09 Aug 2007 15:50:13 -0700
Message-ID: <200708092250.l79MoDFU023564@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50568 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755362AbXHIWvA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Aug 2007 18:51:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, greg@kroah.com, hjk@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     remove dubious legal statment from uio-howto
has been removed from the -mm tree.  Its filename was
     remove-dubious-legal-statment-from-uio-howto.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: remove dubious legal statment from uio-howto
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

UIO currently contains a rather dubious statement which wants removing.

The actual questions around whether user space code that depends tightly
on kernel GPL code designed to co-work with it are derivative works of
the kernel is extremely complex, and since we don't have space for either
a masters length essay on legal issues or need to start flamewars lets
simply remove the comment and leave law to lawyers

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: <hjk@linutronix.de>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DocBook/uio-howto.tmpl |    4 ----
 1 files changed, 4 deletions(-)

diff -puN Documentation/DocBook/uio-howto.tmpl~remove-dubious-legal-statment-from-uio-howto Documentation/DocBook/uio-howto.tmpl
--- a/Documentation/DocBook/uio-howto.tmpl~remove-dubious-legal-statment-from-uio-howto
+++ a/Documentation/DocBook/uio-howto.tmpl
@@ -133,10 +133,6 @@ interested in translating it, please ema
 	<para>updates of your driver can take place without recompiling
 	the kernel.</para>
 </listitem>
-<listitem>
-	<para>if you need to keep some parts of your driver closed source,
-	you can do so without violating the GPL license on the kernel.</para>
-</listitem>
 </itemizedlist>
 
 <sect1 id="how_uio_works">
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
fix-serial-buffer-memory-leak.patch
fix-serial-buffer-memory-leak-fix.patch
nozomi-shoot-defunct-label.patch
git-libata-all.patch
pata_acpi-rework-the-acpi-drivers-based-upon-experience.patch
libata-add-irq_flags-to-struct-pata_platform_info-fix.patch
alpm-store-interrupt-value.patch
alpm-increase-number-of-allowable-device-flags.patch
alpm-enable-link-power-management-for-ata-drivers.patch
alpm-enable-aggressive-link-power-management-for-ahci-controllers.patch
libata-acpi-checks-for-80wire-cable-headers.patch
libata-acpi-checks-for-80wire-cable-implementation.patch
libata-acpi-checks-for-80wire-cable-use-in-pata_amd.patch
libata-acpi-checks-for-80wire-cable-use-in-pata_via.patch
libata-correct-iordy-handling.patch
st340823a-hpa-and-libata.patch
pata_cmd64x-set-up-mwdma-modes-properly.patch
ata_piix-disallow-udma-133-on-ich5-ich7.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
tty-add-the-new-ioctls-and-definitionto-the-mips.patch
add-blacklisting-capability-to-serial_pci-to-avoid-misdetection.patch
add-blacklisting-capability-to-serial_pci-to-avoid-misdetection-fix.patch
dtc-clean-up-indent-damage-and-add-printk-levels.patch
kl5kusb105-switch-to-new-speed-api.patch
mct_u232-convert-to-proper-speed-handling-api-fix.patch
geode-mfgpt-support-for-geode-class-machines.patch
geode-mfgpt-clock-event-device-support.patch
xtensa-enable-arbitary-tty-speed-setting-ioctls.patch
usb-serial-fix-oti6858c-segfault-in-termios-handling.patch
belkin_sa-avoid-divide-by-zero-error.patch
blackfin-enable-arbitary-speed-serial-setting.patch
mxser-remove-use-of-dead-tty_flipbuf_size-definition.patch
jsm-remove-further-unneeded-crud.patch
char-cyclades-remove-bottom-half-processing.patch
