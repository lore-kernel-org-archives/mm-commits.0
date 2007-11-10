From: akpm@linux-foundation.org
Subject: + net-inet_hashtablesh-needs-vmalloch.patch added to -mm tree
Date: Sat, 10 Nov 2007 15:25:23 -0800
Message-ID: <200711102325.lAANPNkD010478@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59838 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755032AbXKJX0Q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 10 Nov 2007 18:26:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dada1@cosmosbay.com, davem@davemloft.net, rolandd@cisco.com, tony.luck@intel.com


The patch titled
     net: inet_hashtables.h needs vmalloc.h
has been added to the -mm tree.  Its filename is
     net-inet_hashtablesh-needs-vmalloch.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

net-inet_hashtablesh-needs-vmalloch.patch
git-net.patch
