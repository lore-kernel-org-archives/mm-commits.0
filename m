From: akpm@linux-foundation.org
Subject: [merged] dynamic_debug-minor-fixes-to-documentation.patch
 removed from -mm tree
Date: Mon, 20 Nov 2017 13:23:47 -0800
Message-ID: <20171120212347.eE0gQaW65%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40168 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752988AbdKTVXs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 20 Nov 2017 16:23:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jbaron@akamai.com, mm-commits@vger.kernel.org, rdunlap@infradead.org


The patch titled
     Subject: dynamic_debug documentation: minor fixes
has been removed from the -mm tree.  Its filename was
     dynamic_debug-minor-fixes-to-documentation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: dynamic_debug documentation: minor fixes

Fix minor typo.

Fix missing words in explaining parsing of last line number.

Link: http://lkml.kernel.org/r/ebb7ff42-4945-103f-d5b4-f07a6f3343a7@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Jason Baron <jbaron@akamai.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/dynamic-debug-howto.rst |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN Documentation/admin-guide/dynamic-debug-howto.rst~dynamic_debug-minor-fixes-to-documentation Documentation/admin-guide/dynamic-debug-howto.rst
--- a/Documentation/admin-guide/dynamic-debug-howto.rst~dynamic_debug-minor-fixes-to-documentation
+++ a/Documentation/admin-guide/dynamic-debug-howto.rst
@@ -18,7 +18,7 @@ shortcut for ``print_hex_dump(KERN_DEBUG
 
 For ``print_hex_dump_debug()``/``print_hex_dump_bytes()``, format string is
 its ``prefix_str`` argument, if it is constant string; or ``hexdump``
-in case ``prefix_str`` is build dynamically.
+in case ``prefix_str`` is built dynamically.
 
 Dynamic debug has even more useful features:
 
@@ -197,8 +197,8 @@ line
     line number matches the callsite line number exactly.  A
     range of line numbers matches any callsite between the first
     and last line number inclusive.  An empty first number means
-    the first line in the file, an empty line number means the
-    last number in the file.  Examples::
+    the first line in the file, an empty last line number means the
+    last line number in the file.  Examples::
 
 	line 1603           // exactly line 1603
 	line 1600-1605      // the six lines from line 1600 to line 1605
_

Patches currently in -mm which might be from rdunlap@infradead.org are


