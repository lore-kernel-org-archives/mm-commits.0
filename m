From: akpm@linux-foundation.org
Subject: [merged] maintainers-mention-scripts-get_maintainerpl-in-the-preface.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:38:35 -0700
Message-ID: <200906171838.n5HIcZOx004630@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35894 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760871AbZFQSju (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:39:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     MAINTAINERS: mention scripts/get_maintainer.pl in the preface
has been removed from the -mm tree.  Its filename was
     maintainers-mention-scripts-get_maintainerpl-in-the-preface.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MAINTAINERS: mention scripts/get_maintainer.pl in the preface
From: Joe Perches <joe@perches.com>

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN MAINTAINERS~maintainers-mention-scripts-get_maintainerpl-in-the-preface MAINTAINERS
--- a/MAINTAINERS~maintainers-mention-scripts-get_maintainerpl-in-the-preface
+++ a/MAINTAINERS
@@ -36,6 +36,12 @@ trivial patch so apply some common sense
 	(scripts/checkpatch.pl) to catch trival style violations.
 	See Documentation/CodingStyle for guidance here.
 
+	PLEASE CC: the maintainers and mailing lists that are generated
+	by scripts/get_maintainer.pl.  The results returned by the
+	script will be best if you have git installed and are making
+	your changes in a branch derived from Linus' latest git tree.
+	See Documentation/SubmittingPatches for details.
+
 	PLEASE try to include any credit lines you want added with the
 	patch. It avoids people being missed off by mistake and makes
 	it easier to know who wants adding and who doesn't.
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
maintainers-fbdev-is-orphaned.patch
lib-add-lib-gcdc-fix.patch
lib-add-lib-gcdc-fix-fix.patch

