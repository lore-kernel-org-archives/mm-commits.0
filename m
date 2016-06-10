From: akpm@linux-foundation.org
Subject: + debugobjectsh-fix-trivial-kernel-doc-warning.patch added to -mm tree
Date: Fri, 10 Jun 2016 15:01:42 -0700
Message-ID: <575b38c6.DvMfrIqNmM5CVfLg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53888 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777AbcFJWBn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 10 Jun 2016 18:01:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rdunlap@infradead.org, mm-commits@vger.kernel.org


The patch titled
     From: Randy Dunlap <rdunlap@infradead.org>
has been added to the -mm tree.  Its filename is
     debugobjectsh-fix-trivial-kernel-doc-warning.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/debugobjectsh-fix-trivial-kernel-doc-warning.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/debugobjectsh-fix-trivial-kernel-doc-warning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>

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

Patches currently in -mm which might be from rdunlap@infradead.org are

debugobjectsh-fix-trivial-kernel-doc-warning.patch
mm-add-missing-kernel-doc-in-mm-memoryc-do_set_pte.patch

