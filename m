From: akpm@linux-foundation.org
Subject: - make-hp_wmi_notify-static.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:20:35 -0700
Message-ID: <200810182320.m9INKZ6M029793@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46306 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751929AbYJRXUo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:20:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, mm-commits@vger.kernel.org


The patch titled
     make hp_wmi_notify() static
has been removed from the -mm tree.  Its filename was
     make-hp_wmi_notify-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: make hp_wmi_notify() static
From: Adrian Bunk <bunk@kernel.org>

Make the needlessly global hp_wmi_notify() static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/hp-wmi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/misc/hp-wmi.c~make-hp_wmi_notify-static drivers/misc/hp-wmi.c
--- a/drivers/misc/hp-wmi.c~make-hp_wmi_notify-static
+++ a/drivers/misc/hp-wmi.c
@@ -309,7 +309,7 @@ static int hp_wmi_setkeycode(struct inpu
 	return -EINVAL;
 }
 
-void hp_wmi_notify(u32 value, void *context)
+static void hp_wmi_notify(u32 value, void *context)
 {
 	struct acpi_buffer response = { ACPI_ALLOCATE_BUFFER, NULL };
 	static struct key_entry *key;
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
make-probe_serial_gsc-static.patch
make-ptrace_untrace-static.patch
make-mm-rmapc-anon_vma_cachep-static.patch
acpi-use-bcd2bin-bin2bcd.patch
alpha-use-bcd2bin-bin2bcd.patch
cris-use-bcd2bin-bin2bcd.patch
drivers-rtc-use-bcd2bin-bin2bcd.patch
rtc-use-bcd2bin-bin2bcd.patch
mips-use-bcd2bin-bin2bcd.patch
mn10300-use-bcd2bin-bin2bcd.patch
i2c-use-bcd2bin-bin2bcd.patch
drivers-scsi-sr_vendorc-use-bcd2bin.patch
remove-the-obsolete-bcdbin-binbcd-macros.patch
include-linux-bcdh-remove-comments.patch

