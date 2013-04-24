From: akpm@linux-foundation.org
Subject: + drivers-net-rename-random32-to-prandom_u32-fix-fix.patch added to -mm tree
Date: Wed, 24 Apr 2013 15:48:01 -0700
Message-ID: <20130424224801.709EE5A4250@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:60768 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758073Ab3DXWsC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 24 Apr 2013 18:48:02 -0400
Received: by mail-vc0-f202.google.com with SMTP id hr11so19015vcb.5
        for <mm-commits@vger.kernel.org>; Wed, 24 Apr 2013 15:48:01 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, arend@broadcom.com


The patch titled
     Subject: brcm80211: fix the misaligned indentation
has been added to the -mm tree.  Its filename is
     drivers-net-rename-random32-to-prandom_u32-fix-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: brcm80211: fix the misaligned indentation

This fixes the misaligned indentation introduced by
drivers-net-rename-random32-to-prandom_u32.patch in the -mm tree.

This also remove unneeded parentheses in order not to cause line over
80 characters.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Acked-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wireless/brcm80211/brcmfmac/p2p.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/wireless/brcm80211/brcmfmac/p2p.c~drivers-net-rename-random32-to-prandom_u32-fix-fix drivers/net/wireless/brcm80211/brcmfmac/p2p.c
--- a/drivers/net/wireless/brcm80211/brcmfmac/p2p.c~drivers-net-rename-random32-to-prandom_u32-fix-fix
+++ a/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
@@ -1117,7 +1117,7 @@ static void brcmf_p2p_afx_handler(struct
 	if (afx_hdl->is_listen && afx_hdl->my_listen_chan)
 		/* 100ms ~ 300ms */
 		err = brcmf_p2p_discover_listen(p2p, afx_hdl->my_listen_chan,
-					100 * (1 + (prandom_u32() % 3)));
+						100 * (1 + prandom_u32() % 3));
 	else
 		err = brcmf_p2p_act_frm_search(p2p, afx_hdl->peer_listen_chan);
 
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

linux-next.patch
raid6test-use-prandom_bytes.patch
uuid-use-prandom_bytes.patch
x86-pageattr-test-remove-srandom32-call.patch
x86-rename-random32-to-prandom_u32.patch
lib-rename-random32-to-prandom_u32.patch
mm-rename-random32-to-prandom_u32.patch
kernel-rename-random32-to-prandom_u32.patch
drbd-rename-random32-to-prandom_u32.patch
mmc-rename-random32-to-prandom_u32.patch
video-uvesafb-rename-random32-to-prandom_u32.patch
uwb-rename-random32-to-prandom_u32.patch
lguest-rename-random32-to-prandom_u32.patch
scsi-rename-random32-to-prandom_u32.patch
drivers-net-rename-random32-to-prandom_u32.patch
drivers-net-rename-random32-to-prandom_u32-fix.patch
drivers-net-rename-random32-to-prandom_u32-fix-fix.patch
net-sunrpc-rename-random32-to-prandom_u32.patch
net-sched-rename-random32-to-prandom_u32.patch
net-netfilter-rename-random32-to-prandom_u32.patch
net-core-rename-random32-to-prandom_u32.patch
net-core-remove-duplicate-statements-by-do-while-loop.patch
net-rename-random32-to-prandom.patch
remove-unused-random32-and-srandom32.patch

