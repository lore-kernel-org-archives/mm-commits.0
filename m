From: akpm@linux-foundation.org
Subject: + doc-console-doc-should-read-bind-unbind-instead-of-bind-bind.patch added to -mm tree
Date: Mon, 01 Feb 2010 14:31:34 -0800
Message-ID: <201002012231.o11MVYoC016613@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33755 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755055Ab0BAWbk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Feb 2010 17:31:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cascardo@holoscopio.com, randy.dunlap@oracle.com


The patch titled
     doc: console doc should read "bind & unbind" instead of "bind & bind"
has been added to the -mm tree.  Its filename is
     doc-console-doc-should-read-bind-unbind-instead-of-bind-bind.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: doc: console doc should read "bind & unbind" instead of "bind & bind"
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/console/console.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/console/console.txt~doc-console-doc-should-read-bind-unbind-instead-of-bind-bind Documentation/console/console.txt
--- a/Documentation/console/console.txt~doc-console-doc-should-read-bind-unbind-instead-of-bind-bind
+++ a/Documentation/console/console.txt
@@ -74,7 +74,7 @@ driver takes over the consoles vacated b
 hand, will bind the driver to the consoles that are currently occupied by a
 system driver.
 
-NOTE1: Binding and binding must be selected in Kconfig. It's under:
+NOTE1: Binding and unbinding must be selected in Kconfig. It's under:
 
 Device Drivers -> Character devices -> Support for binding and unbinding
 console drivers
_

Patches currently in -mm which might be from cascardo@holoscopio.com are

linux-next.patch
eisa-fix-coding-style-for-eisa-bus-code.patch
doc-console-doc-should-read-bind-unbind-instead-of-bind-bind.patch

