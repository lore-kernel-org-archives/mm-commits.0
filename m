From: akpm@linux-foundation.org
Subject: [folded-merged] drivers-net-rename-random32-to-prandom_u32-fix-fix.patch removed from -mm tree
Date: Tue, 07 May 2013 12:40:01 -0700
Message-ID: <20130507194001.A4C8D31C15F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:34874 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752033Ab3EGTkC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 May 2013 15:40:02 -0400
Received: by mail-gg0-f202.google.com with SMTP id 4so99692ggm.5
        for <mm-commits@vger.kernel.org>; Tue, 07 May 2013 12:40:02 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, arend@broadcom.com, mm-commits@vger.kernel.org


The patch titled
     Subject: brcm80211: fix the misaligned indentation
has been removed from the -mm tree.  Its filename was
     drivers-net-rename-random32-to-prandom_u32-fix-fix.patch

This patch was dropped because it was folded into drivers-net-rename-random32-to-prandom_u32.patch

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

origin.patch
drivers-net-rename-random32-to-prandom_u32.patch
remove-unused-random32-and-srandom32.patch
linux-next.patch

