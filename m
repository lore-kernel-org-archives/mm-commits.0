From: akpm@linux-foundation.org
Subject: - nozomi-shoot-defunct-label.patch removed from -mm tree
Date: Mon, 20 Aug 2007 12:12:04 -0700
Message-ID: <200708201912.l7KJC4kw018319@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34116 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760012AbXHTTV0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Aug 2007 15:21:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     nozomi: shoot defunct label
has been removed from the -mm tree.  Its filename was
     nozomi-shoot-defunct-label.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: nozomi: shoot defunct label
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

No longer called after the cleanup so can go in the bitbucket.

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/nozomi.c |    1 -
 1 files changed, 1 deletion(-)

diff -puN drivers/char/nozomi.c~nozomi-shoot-defunct-label drivers/char/nozomi.c
--- a/drivers/char/nozomi.c~nozomi-shoot-defunct-label
+++ a/drivers/char/nozomi.c
@@ -1930,7 +1930,6 @@ static void ntty_set_termios(struct tty_
 			D1(" - OUTBOUND XON/XOFF is disabled");
 	}
 
-      exit_termios:
 	return;
 }
 
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
serial-add-support-for-ite-887x-chips.patch
serial_txx9-fix-modem-control-line-handling.patch
serial-8250-handle-saving-the-clear-on-read-bits-from-the-lsr.patch
add-blacklisting-capability-to-serial_pci-to-avoid-misdetection.patch
fix-null-pointer-dereference-in-__vm_enough_memory.patch
m68k-enable-arbitary-speed-tty-support.patch
introduce-config_check_signature-was-re-uninline.patch
git-libata-all.patch
pata_acpi-rework-the-acpi-drivers-based-upon-experience.patch
libata-acpi-checks-for-80wire-cable-implementation.patch
st340823a-hpa-and-libata.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
tty-add-the-new-ioctls-and-definitionto-the-mips.patch
serial_txx9-cleanup-includes.patch
git-scsi-misc.patch
geode-mfgpt-support-for-geode-class-machines.patch
geode-mfgpt-clock-event-device-support.patch
xtensa-enable-arbitary-tty-speed-setting-ioctls.patch
pci-align-bar-settings-for-legacy-mode-ide.patch
blackfin-enable-arbitary-speed-serial-setting.patch
mxser-remove-use-of-dead-tty_flipbuf_size-definition.patch
jsm-remove-further-unneeded-crud.patch
sysctl-remove-broken-cdrom-binary-sysctls.patch
char-cyclades-remove-bottom-half-processing.patch
