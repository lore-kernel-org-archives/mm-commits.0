From: akpm@linux-foundation.org
Subject: [merged] lib-assoc_arrayc-remove-global-variable.patch removed
 from -mm tree
Date: Thu, 23 Jan 2014 12:42:36 -0800
Message-ID: <52e17ebc.pfGFdwoXMI+eJjTi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36050 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751108AbaAWUmh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 23 Jan 2014 15:42:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stephen@networkplumber.org, dhowells@redhat.com, shemming@brocade.com

Subject: [merged] lib-assoc_arrayc-remove-global-variable.patch removed from -mm tree
To: shemming@brocade.com,dhowells@redhat.com,stephen@networkplumber.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 23 Jan 2014 12:42:36 -0800


The patch titled
     Subject: lib/assoc_array.c: remove global variable
has been removed from the -mm tree.  Its filename was
     lib-assoc_arrayc-remove-global-variable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Stephen Hemminger <shemming@brocade.com>
Subject: lib/assoc_array.c: remove global variable

The associative array code creates unnecessary and potentially problematic
global variable 'status'.  Remove it since it is never used.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/assoc_array.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/assoc_array.c~lib-assoc_arrayc-remove-global-variable lib/assoc_array.c
--- a/lib/assoc_array.c~lib-assoc_arrayc-remove-global-variable
+++ a/lib/assoc_array.c
@@ -157,7 +157,7 @@ enum assoc_array_walk_status {
 	assoc_array_walk_tree_empty,
 	assoc_array_walk_found_terminal_node,
 	assoc_array_walk_found_wrong_shortcut,
-} status;
+};
 
 struct assoc_array_walk_result {
 	struct {
_

Patches currently in -mm which might be from shemming@brocade.com are

origin.patch
linux-next.patch

