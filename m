From: akpm@linux-foundation.org
Subject: [merged] wireless-at76c50x-follow-rename-pack_hex_byte-to-hex_byte_pack.patch removed from -mm tree
Date: Tue, 01 Nov 2011 14:16:42 -0700
Message-ID: <201111012116.pA1LGgo8014980@wpaz17.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:30329 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753117Ab1KAVRB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Nov 2011 17:17:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andriy.shevchenko@linux.intel.com, linville@tuxdriver.com, mm-commits@vger.kernel.org


The patch titled
     Subject: wireless: at76c50x: follow rename pack_hex_byte to hex_byte_pack
has been removed from the -mm tree.  Its filename was
     wireless-at76c50x-follow-rename-pack_hex_byte-to-hex_byte_pack.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: wireless: at76c50x: follow rename pack_hex_byte to hex_byte_pack

There is no functional change.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/at76c50x-usb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/wireless/at76c50x-usb.c~wireless-at76c50x-follow-rename-pack_hex_byte-to-hex_byte_pack drivers/net/wireless/at76c50x-usb.c
--- a/drivers/net/wireless/at76c50x-usb.c~wireless-at76c50x-follow-rename-pack_hex_byte-to-hex_byte_pack
+++ a/drivers/net/wireless/at76c50x-usb.c
@@ -517,7 +517,7 @@ static char *hex2str(void *buf, size_t l
 		goto exit;
 
 	while (len--) {
-		obuf = pack_hex_byte(obuf, *ibuf++);
+		obuf = hex_byte_pack(obuf, *ibuf++);
 		*obuf++ = '-';
 	}
 	obuf--;
_

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

origin.patch
linux-next.patch
selinuxfs-remove-custome-hex_to_bin.patch

