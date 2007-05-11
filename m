From: akpm@linux-foundation.org
Subject: + module_author-dont-advice-putting-in-an-email-address.patch added to -mm tree
Date: Thu, 10 May 2007 20:43:06 -0700
Message-ID: <200705110343.l4B3h66U005426@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:46672 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751555AbXEKDnP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 May 2007 23:43:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rene.herman@gmail.com, rusty@rustcorp.com.au


The patch titled
     module_author: don't advice putting in an email address
has been added to the -mm tree.  Its filename is
     module_author-dont-advice-putting-in-an-email-address.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: module_author: don't advice putting in an email address
From: Rene Herman <rene.herman@gmail.com>

module_author: don't advice putting in an email address

It's information that's easily outdated and easily mistaken for a driver
contact which is a problem especially for modules with multiple current and
non-current authors as well as for modules with a maintainer who may not
even be a module author.

Signed-off-by: Rene Herman <rene.herman@gmail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/module.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/module.h~module_author-dont-advice-putting-in-an-email-address include/linux/module.h
--- a/include/linux/module.h~module_author-dont-advice-putting-in-an-email-address
+++ a/include/linux/module.h
@@ -124,7 +124,7 @@ extern struct module __this_module;
  */
 #define MODULE_LICENSE(_license) MODULE_INFO(license, _license)
 
-/* Author, ideally of form NAME <EMAIL>[, NAME <EMAIL>]*[ and NAME <EMAIL>] */
+/* Author, ideally of form NAME[, NAME]*[ and NAME] */
 #define MODULE_AUTHOR(_author) MODULE_INFO(author, _author)
   
 /* What your module does. */
_

Patches currently in -mm which might be from rene.herman@gmail.com are

origin.patch
git-alsa.patch
module_author-dont-advice-putting-in-an-email-address.patch
