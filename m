From: akpm@linux-foundation.org
Subject: [merged] serial-add-supraexpress-336i-pnp-voice-modem-fix.patch removed from -mm tree
Date: Fri, 16 Jan 2009 11:18:35 -0800
Message-ID: <200901161918.n0GJIZeV027174@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44651 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765828AbZAPTTE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Jan 2009 14:19:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, daniel.gagnon@yahoo.com, mm-commits@vger.kernel.org


The patch titled
     serial-add-supraexpress-336i-pnp-voice-modem-fix
has been removed from the -mm tree.  Its filename was
     serial-add-supraexpress-336i-pnp-voice-modem-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: serial-add-supraexpress-336i-pnp-voice-modem-fix
From: Andrew Morton <akpm@linux-foundation.org>

argh.  Fix my fix for Daniel's MUA-munched whitespace.

Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Daniel Gagnon <daniel.gagnon@yahoo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/8250_pnp.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/serial/8250_pnp.c~serial-add-supraexpress-336i-pnp-voice-modem-fix drivers/serial/8250_pnp.c
--- a/drivers/serial/8250_pnp.c~serial-add-supraexpress-336i-pnp-voice-modem-fix
+++ a/drivers/serial/8250_pnp.c
@@ -270,8 +270,8 @@ static const struct pnp_device_id pnp_de
 	{       "RSS0250",              0       },
 	/* SupraExpress 28.8 Data/Fax PnP modem */
 	{	"SUP1310",		0	},
- 	/* SupraExpress 336i PnP Voice Modem */
- 	{       "SUP1381",              0       },
+	/* SupraExpress 336i PnP Voice Modem */
+	{       "SUP1381",              0       },
 	/* SupraExpress 33.6 Data/Fax PnP modem */
 	{	"SUP1421",		0	},
 	/* SupraExpress 33.6 Data/Fax PnP modem */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
kprobes-fix-module-compilation-error-with-config_kprobes=n-fix.patch
i-need-old-gcc.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
thinkpad-acpi-split-delayed-leds-stuff-clean-up-code-checkpatch-fixes.patch
drivers-consolidate-driver_probe_done-loops-into-one-place-fix.patch
drivers-consolidate-driver_probe_done-loops-into-one-place-checkpatch-fixes.patch
clocksource-pass-clocksource-to-read-callback.patch
drivers-net-mlx4-profilec-fix-min-warning.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets.patch
regulator-minor-cleanup-of-virtual-consumer-fix.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
nommu-fix-a-number-of-issues-with-the-per-mm-vma-patch.patch
page_fault-retry-with-nopage_retry.patch
page_fault-retry-with-nopage_retry-fix-3-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix.patch
mm-add-proc-controls-for-pdflush-threads-fix-fix.patch
proc-pid-maps-dont-show-pgoff-of-pure-anon-vmas-checkpatch-fixes.patch
rtc-convert-leap_year-into-an-inline.patch
rtc-add-platform-driver-for-efi-fix.patch
nilfs2-integrated-block-mapping-remove-nilfs-bmap-wrapper-macros-checkpatch-fixes.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
nilfs2-super-block-operations-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

