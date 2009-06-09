From: akpm@linux-foundation.org
Subject: + documentation-make-version-fix.patch added to -mm tree
Date: Tue, 09 Jun 2009 15:06:29 -0700
Message-ID: <200906092206.n59M6TjN014498@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49936 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751506AbZFIWHU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jun 2009 18:07:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adam@os.inf.tu-dresden.de, sam@ravnborg.org


The patch titled
     documentation: make version fix
has been added to the -mm tree.  Its filename is
     documentation-make-version-fix.patch

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
Subject: documentation: make version fix
From: Adam Lackorzynski <adam@os.inf.tu-dresden.de>

The Makefiles in the build directories use the internal make variable
MAKEFILE_LIST which is available from make 3.80 only.  (The patch would be
valid back to 2.6.25)

Signed-off-by: Adam Lackorzynski <adam@os.inf.tu-dresden.de>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/Changes |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN Documentation/Changes~documentation-make-version-fix Documentation/Changes
--- a/Documentation/Changes~documentation-make-version-fix
+++ a/Documentation/Changes
@@ -29,7 +29,7 @@ hardware, for example, you probably need
 isdn4k-utils.
 
 o  Gnu C                  3.2                     # gcc --version
-o  Gnu make               3.79.1                  # make --version
+o  Gnu make               3.80                    # make --version
 o  binutils               2.12                    # ld -v
 o  util-linux             2.10o                   # fdformat --version
 o  module-init-tools      0.9.10                  # depmod -V
@@ -62,7 +62,7 @@ computer.
 Make
 ----
 
-You will need Gnu make 3.79.1 or later to build the kernel.
+You will need Gnu make 3.80 or later to build the kernel.
 
 Binutils
 --------
_

Patches currently in -mm which might be from adam@os.inf.tu-dresden.de are

jsm-clean-up-serial-jsm-correctly-support-4-8-port-boards.patch
documentation-make-version-fix.patch

