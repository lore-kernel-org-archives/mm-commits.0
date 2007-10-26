From: akpm@linux-foundation.org
Subject: - lguest-build-fix.patch removed from -mm tree
Date: Fri, 26 Oct 2007 11:48:04 -0700
Message-ID: <200710261848.l9QIm4CQ009108@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53693 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751973AbXJZSs2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Oct 2007 14:48:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeff@garzik.org, jgarzik@redhat.com, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     lguest: build fix
has been removed from the -mm tree.  Its filename was
     lguest-build-fix.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

------------------------------------------------------
Subject: lguest: build fix
=46rom: Jeff Garzik <jeff@garzik.org>

=46ix this error (i386 !SMP build)

arch/x86/lguest/boot.c: In function =E2=80=98lguest_init=E2=80=99:
arch/x86/lguest/boot.c:1059: error: =E2=80=98pm_power_off=E2=80=99 unde=
clared (first use in this function)

by including linux/pm.h.

Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/lguest/boot.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/x86/lguest/boot.c~lguest-build-fix arch/x86/lguest/boot.=
c
--- a/arch/x86/lguest/boot.c~lguest-build-fix
+++ a/arch/x86/lguest/boot.c
@@ -56,6 +56,7 @@
 #include <linux/lguest.h>
 #include <linux/lguest_launcher.h>
 #include <linux/virtio_console.h>
+#include <linux/pm.h>
 #include <asm/paravirt.h>
 #include <asm/param.h>
 #include <asm/page.h>
_

Patches currently in -mm which might be from jeff@garzik.org are

origin.patch
remove-bogus-default-y-for-dmar-and-net_dma.patch
acpi-sbs-fix-retval-warning.patch
git-jg-misc.patch
git-libata-all.patch
drivers-ata-libata-ehc-fix-printk-warning.patch
ide-add-helper-__ide_setup_pci_device.patch
drivers-ide-pci-sc1200c-remove-pointless-hwif-lookup-loop.patch
drivers-ide-pci-sc1200c-remove-pointless-hwif-lookup-loop-checkpatch-fi=
xes.patch
git-netdev-all.patch
forcedeth-power-down-phy-when-interface-is-down.patch
forcedeth-fix-mac-address-detection-on-network-card-regression-in-2623.=
patch
ucc_geth-fix-build-break-introduced-by-commit-09f75cd7bf13720738e6a196c=
c0107ce9a5bd5a0-checkpatch-fixes.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
hptiop-fix-type-mismatch-warning.patch
ips-remove-ips_ha-members-that-duplicate-struct-pci_dev-members.patch
ips-trim-trailing-whitespace.patch
ips-trim-trailing-whitespace-checkpatch-fixes.patch
ips-pci-api-cleanups.patch
ips-handle-scsi_add_host-failure-and-other-err-cleanups.patch
git-wireless.patch
x86-fix-config_smp-warning-in-processorc.patch
x86-fix-config_smp-warning-in-processorc-fix.patch
fix-versus-precedence-in-various-places.patch
fix-versus-precedence-in-various-places-checkpatch-fixes.patch
riscom8-fix-smp-brokenness.patch
riscom8-fix-smp-brokenness-fix.patch
sound-oss-pss-set_io_base-always-returns-success-mark-it-void.patch
sound-oss-pss-set_io_base-always-returns-success-mark-it-void-checkpatc=
h-fixes.patch
sound-oss-sb_commonc-fix-casting-warning.patch
remove-warnings-for-longstanding-conditions.patch
remove-warnings-for-longstanding-conditions-fix.patch
remove-warnings-for-longstanding-conditions-checkpatch-fixes.patch
