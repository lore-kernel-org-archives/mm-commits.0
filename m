From: akpm@linux-foundation.org
Subject: - net-af_packet-remove-unused-variable.patch removed from -mm tree
Date: Mon, 24 Mar 2008 17:19:08 -0700
Message-ID: <200803250019.m2P0J8jX032659@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40345 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753164AbYCYATt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Mar 2008 20:19:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: olsajiri@gmail.com, davem@davemloft.net, mm-commits@vger.kernel.org


The patch titled
     net: af_packet: remove unused variable
has been removed from the -mm tree.  Its filename was
     net-af_packet-remove-unused-variable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: net: af_packet: remove unused variable
From: Jiri Olsa <olsajiri@gmail.com>

Signed-off-by: Jiri Olsa <olsajiri@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/packet/af_packet.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN net/packet/af_packet.c~net-af_packet-remove-unused-variable net/packet/af_packet.c
--- a/net/packet/af_packet.c~net-af_packet-remove-unused-variable
+++ a/net/packet/af_packet.c
@@ -1658,7 +1658,7 @@ static int packet_set_ring(struct sock *
 	int err = 0;
 
 	if (req->tp_block_nr) {
-		int i, l;
+		int i;
 
 		/* Sanity tests and some calculations */
 
@@ -1687,7 +1687,6 @@ static int packet_set_ring(struct sock *
 		if (unlikely(!pg_vec))
 			goto out;
 
-		l = 0;
 		for (i = 0; i < req->tp_block_nr; i++) {
 			char *ptr = pg_vec[i];
 			struct tpacket_hdr *header;
_

Patches currently in -mm which might be from olsajiri@gmail.com are

git-net.patch
fs-remove-unused-fops-from-struct-char_device_struct.patch

