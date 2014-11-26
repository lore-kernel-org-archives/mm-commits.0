From: akpm@linux-foundation.org
Subject: [merged] gitignore-add-kdevelop4-project-files.patch removed from -mm tree
Date: Wed, 26 Nov 2014 00:29:38 -0800
Message-ID: <54758f72.RBYYxtHnPBCQYkj5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57246 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841AbaKZI3R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 26 Nov 2014 03:29:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: boaz@plexistor.com, mmarek@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: .gitignore: Add Kdevelop4 project files
has been removed from the -mm tree.  Its filename was
     gitignore-add-kdevelop4-project-files.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Boaz Harrosh <boaz@plexistor.com>
Subject: .gitignore: Add Kdevelop4 project files

I'm not sure what is the custom with such IDE project files.  Most might
be dot-files.  It is kind of annoying for the Kdevelop4 user.

So please consider adding *.kdev4 files to be ignored.

Signed-off-by: Boaz Harrosh <boaz@plexistor.com>
Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .gitignore |    1 +
 1 file changed, 1 insertion(+)

diff -puN .gitignore~gitignore-add-kdevelop4-project-files .gitignore
--- a/.gitignore~gitignore-add-kdevelop4-project-files
+++ a/.gitignore
@@ -35,6 +35,7 @@
 modules.builtin
 Module.symvers
 *.dwo
+*.kdev4
 
 #
 # Top-level generic files
_

Patches currently in -mm which might be from boaz@plexistor.com are


