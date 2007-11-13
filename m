From: akpm@linux-foundation.org
Subject: - net-inet_hashtablesh-needs-vmalloch.patch removed from -mm tree
Date: Mon, 12 Nov 2007 20:08:06 -0800
Message-ID: <200711130408.lAD485kq025280@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45479 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756801AbXKMESH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Nov 2007 23:18:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dada1@cosmosbay.com, davem@davemloft.net, rolandd@cisco.com, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     net: inet_hashtables.h needs vmalloc.h
has been removed from the -mm tree.  Its filename was
     net-inet_hashtablesh-needs-vmalloch.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: net: inet_hashtables.h needs vmalloc.h
From: Eric Dumazet <dada1@cosmosbay.com>

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Roland Dreier <rolandd@cisco.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/net/inet_hashtables.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/net/inet_hashtables.h~net-inet_hashtablesh-needs-vmalloch include/net/inet_hashtables.h
--- a/include/net/inet_hashtables.h~net-inet_hashtablesh-needs-vmalloch
+++ a/include/net/inet_hashtables.h
@@ -23,6 +23,7 @@
 #include <linux/spinlock.h>
 #include <linux/types.h>
 #include <linux/wait.h>
+#include <linux/vmalloc.h>
 
 #include <net/inet_connection_sock.h>
 #include <net/inet_sock.h>
_

Patches currently in -mm which might be from dada1@cosmosbay.com are

origin.patch
