From: akpm@linux-foundation.org
Subject: + gitignore-add-kdevelop4-project-files.patch added to -mm tree
Date: Tue, 25 Nov 2014 16:08:43 -0800
Message-ID: <54751a0b.nKla+cygMutC5vF4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52204 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891AbaKZAIV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 25 Nov 2014 19:08:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: boaz@plexistor.com, mmarek@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: .gitignore: Add Kdevelop4 project files
has been added to the -mm tree.  Its filename is
     gitignore-add-kdevelop4-project-files.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/gitignore-add-kdevelop4-project-files.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/gitignore-add-kdevelop4-project-files.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

gitignore-add-kdevelop4-project-files.patch

