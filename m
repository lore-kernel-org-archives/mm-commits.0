From: akpm@linux-foundation.org
Subject: [merged] build-trivia-scripts-headers_installsh.patch removed
 from -mm tree
Date: Tue, 14 Oct 2014 11:21:56 -0700
Message-ID: <543d69c4.vSsoX1cM+WdJqXL/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44465 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754638AbaJNSVz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Oct 2014 14:21:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: javier.barrio.mart@gmail.com, mmarek@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/headers_install.sh: fix error handling
has been removed from the -mm tree.  Its filename was
     build-trivia-scripts-headers_installsh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Javier Barrio <javier.barrio.mart@gmail.com>
Subject: scripts/headers_install.sh: fix error handling

- headers_install requires at least two arguments

- missed closing quote

Signed-off-by: Javier Barrio <javier.barrio.mart@gmail.com>
Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/headers_install.sh |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN scripts/headers_install.sh~build-trivia-scripts-headers_installsh scripts/headers_install.sh
--- a/scripts/headers_install.sh~build-trivia-scripts-headers_installsh
+++ a/scripts/headers_install.sh
@@ -1,8 +1,8 @@
 #!/bin/sh
 
-if [ $# -lt 1 ]
+if [ $# -lt 2 ]
 then
-	echo "Usage: headers_install.sh OUTDIR SRCDIR [FILES...]
+	echo "Usage: headers_install.sh OUTDIR SRCDIR [FILES...]"
 	echo
 	echo "Prepares kernel header files for use by user space, by removing"
 	echo "all compiler.h definitions and #includes, removing any"
_

Patches currently in -mm which might be from javier.barrio.mart@gmail.com are

origin.patch

