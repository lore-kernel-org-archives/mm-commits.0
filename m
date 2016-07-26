From: akpm@linux-foundation.org
Subject: [patch 010/126] debugobjects.h: fix trivial kernel doc warning
Date: Tue, 26 Jul 2016 15:21:26 -0700
Message-ID: <5797e266.R5creJlEoO4X+voB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56447 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757048AbcGZWV1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jul 2016 18:21:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, rdunlap@infradead.org

From: Randy Dunlap <rdunlap@infradead.org>
Subject: debugobjects.h: fix trivial kernel doc warning

Add ':' to fix trivial kernel-doc warning in <linux/debugobjects.h>:

..//include/linux/debugobjects.h:63: warning: No description found for parameter 'is_static_object'

Link: http://lkml.kernel.org/r/575B01B8.5060600@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/debugobjects.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/debugobjects.h~debugobjectsh-fix-trivial-kernel-doc-warning include/linux/debugobjects.h
--- a/include/linux/debugobjects.h~debugobjectsh-fix-trivial-kernel-doc-warning
+++ a/include/linux/debugobjects.h
@@ -38,7 +38,7 @@ struct debug_obj {
  * @name:		name of the object typee
  * @debug_hint:		function returning address, which have associated
  *			kernel symbol, to allow identify the object
- * @is_static_object	return true if the obj is static, otherwise return false
+ * @is_static_object:	return true if the obj is static, otherwise return false
  * @fixup_init:		fixup function, which is called when the init check
  *			fails. All fixup functions must return true if fixup
  *			was successful, otherwise return false
_
