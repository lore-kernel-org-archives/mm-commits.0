From: akpm@linux-foundation.org
Subject: + wireless-at76c50x-follow-rename-pack_hex_byte-to-hex_byte_pack.patch added to -mm tree
Date: Tue, 18 Oct 2011 14:01:57 -0700
Message-ID: <201110182101.p9IL1wAq004767@hpaq1.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:41604 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754097Ab1JRVC2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Oct 2011 17:02:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andriy.shevchenko@linux.intel.com, linville@tuxdriver.com


The patch titled
     Subject: wireless: at76c50x: follow rename pack_hex_byte to hex_byte_pack
has been added to the -mm tree.  Its filename is
     wireless-at76c50x-follow-rename-pack_hex_byte-to-hex_byte_pack.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
Subject: Subject: wireless: at76c50x: follow rename pack_hex_byte to hex_byte_pack

Patches currently in -mm which might be from andriy.shevchenko@linux.intel.com are

linux-next.patch
selinuxfs-remove-custome-hex_to_bin.patch
lib-rename-pack_hex_byte-to-hex_byte_pack.patch
kgdb-follow-rename-pack_hex_byte-to-hex_byte_pack.patch
security-follow-rename-pack_hex_byte-to-hex_byte_pack.patch
fat-follow-rename-pack_hex_byte-to-hex_byte_pack.patch
wireless-at76c50x-follow-rename-pack_hex_byte-to-hex_byte_pack.patch

