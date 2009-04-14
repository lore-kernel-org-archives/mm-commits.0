From: akpm@linux-foundation.org
Subject: [merged] mm-point-the-unevictable_lru-config-option-at-the-documentation.patch removed from -mm tree
Date: Tue, 14 Apr 2009 12:49:28 -0700
Message-ID: <200904141949.n3EJnSP6019652@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38520 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753993AbZDNTxd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Apr 2009 15:53:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, kosaki.motohiro@jp.fujitsu.com, lee.schermerhorn@hp.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     mm: point the UNEVICTABLE_LRU config option at the documentation
has been removed from the -mm tree.  Its filename was
     mm-point-the-unevictable_lru-config-option-at-the-documentation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: point the UNEVICTABLE_LRU config option at the documentation
From: David Howells <dhowells@redhat.com>

Point the UNEVICTABLE_LRU config option at the documentation describing
the option.

Signed-off-by: David Howells <dhowells@redhat.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/Kconfig |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/Kconfig~mm-point-the-unevictable_lru-config-option-at-the-documentation mm/Kconfig
--- a/mm/Kconfig~mm-point-the-unevictable_lru-config-option-at-the-documentation
+++ a/mm/Kconfig
@@ -213,6 +213,8 @@ config UNEVICTABLE_LRU
 	  will use one page flag and increase the code size a little,
 	  say Y unless you know what you are doing.
 
+	  See Documentation/vm/unevictable-lru.txt for more information.
+
 config HAVE_MLOCK
 	bool
 	default y if MMU=y
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
rxrpc-fix-error-handling-for-rxrpc_alloc_connection.patch
frv-duplicate-output_buffer-of-e03.patch
flat-fix-data-sections-alignment.patch
mutex-subsystem-synchro-test-module.patch

