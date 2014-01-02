From: akpm@linux-foundation.org
Subject: + lib-assoc_arrayc-remove-global-variable.patch added to -mm tree
Date: Thu, 02 Jan 2014 15:18:55 -0800
Message-ID: <52c5f3df.E3XccO0yimKDMMBu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43266 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966AbaABXS4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Jan 2014 18:18:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stephen@networkplumber.org, dhowells@redhat.com, shemming@brocade.com

Subject: + lib-assoc_arrayc-remove-global-variable.patch added to -mm tree
To: shemming@brocade.com,dhowells@redhat.com,stephen@networkplumber.org
From: akpm@linux-foundation.org
Date: Thu, 02 Jan 2014 15:18:55 -0800


The patch titled
     Subject: lib/assoc_array.c: remove global variable
has been added to the -mm tree.  Its filename is
     lib-assoc_arrayc-remove-global-variable.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-assoc_arrayc-remove-global-variable.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-assoc_arrayc-remove-global-variable.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

lib-assoc_arrayc-remove-global-variable.patch
linux-next.patch

