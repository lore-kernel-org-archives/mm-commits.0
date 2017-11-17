From: akpm@linux-foundation.org
Subject: [patch 25/94] dynamic_debug documentation: minor fixes
Date: Fri, 17 Nov 2017 15:27:39 -0800
Message-ID: <20171117232739.NouE6pHF5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55410 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1423266AbdKQX1k (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 17 Nov 2017 18:27:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jbaron@akamai.com, mm-commits@vger.kernel.org, rdunlap@infradead.org, torvalds@linux-foundation.org

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
