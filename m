From: akpm@linux-foundation.org
Subject: - hp-wmi-additional-keycode-or-typo.patch removed from -mm tree
Date: Mon, 20 Oct 2008 13:34:42 -0700
Message-ID: <200810202034.m9KKYg2n010908@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51200 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753762AbYJTUhC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 16:37:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: eric.piel@tremplin-utc.net, mjg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     HP-WMI: additional keycode (or typo)
has been removed from the -mm tree.  Its filename was
     hp-wmi-additional-keycode-or-typo.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: HP-WMI: additional keycode (or typo)
From: Eric Piel <eric.piel@tremplin-utc.net>

On my HP 2510, pressing the (i) button generates an unknown keycode:
0x213b. So here is a patch adding support for it. However, as it seems
there is already support for a similar button connected to 0x231b as
keycode, I wonder if it could be a typo in the driver?

Signed-off-by: Eric Piel <eric.piel@tremplin-utc.net>
Cc: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/hp-wmi.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/misc/hp-wmi.c~hp-wmi-additional-keycode-or-typo drivers/misc/hp-wmi.c
--- a/drivers/misc/hp-wmi.c~hp-wmi-additional-keycode-or-typo
+++ a/drivers/misc/hp-wmi.c
@@ -82,6 +82,7 @@ static struct key_entry hp_wmi_keymap[] 
 	{KE_KEY, 0x03, KEY_BRIGHTNESSDOWN},
 	{KE_KEY, 0x20e6, KEY_PROG1},
 	{KE_KEY, 0x2142, KEY_MEDIA},
+	{KE_KEY, 0x213b, KEY_INFO},
 	{KE_KEY, 0x231b, KEY_HELP},
 	{KE_END, 0}
 };
_

Patches currently in -mm which might be from eric.piel@tremplin-utc.net are

origin.patch
leds-driver-for-hp-harddisk-protection-led.patch
leds-driver-for-hp-harddisk-protection-led-fix.patch

