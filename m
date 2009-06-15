From: akpm@linux-foundation.org
Subject: [merged] documentation-make-version-fix.patch removed from -mm tree
Date: Mon, 15 Jun 2009 12:01:53 -0700
Message-ID: <200906151901.n5FJ1rYg023271@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50312 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763743AbZFOTCD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Jun 2009 15:02:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adam@os.inf.tu-dresden.de, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     documentation: make version fix
has been removed from the -mm tree.  Its filename was
     documentation-make-version-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
jsm-clean-up-serial-jsm-correctly-support-4-8-port-boards.patch

