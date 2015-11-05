From: akpm@linux-foundation.org
Subject: + get_maintainer-add-no-foo-options-to-help.patch added to -mm
 tree
Date: Wed, 04 Nov 2015 17:32:04 -0800
Message-ID: <563ab194.f9S75vEhBlUQFXze%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47810 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031510AbbKEBcF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Nov 2015 20:32:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: computersforpeace@gmail.com, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: get_maintainer: add --no-foo options to --help
has been added to the -mm tree.  Its filename is
     get_maintainer-add-no-foo-options-to-help.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/get_maintainer-add-no-foo-options-to-help.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/get_maintainer-add-no-foo-options-to-help.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Brian Norris <computersforpeace@gmail.com>
Subject: get_maintainer: add --no-foo options to --help

Many flag options are boolean and support both a positive and a negative
invocation from the command line.  Some of these are even mentioned by
example (e.g., --nogit is mentioned as a default option), but they aren't
explicitly mentioned in the list of options.  It happens that some of
these are pretty important, as they are default-on, and to turn them off,
you have to know about the --no-foo version.

Rather than clutter the whole help text with bracketed '--[no]foo', let's
just mention the general rule, a la 'man gcc'.

Signed-off-by: Brian Norris <computersforpeace@gmail.com>
Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/get_maintainer.pl |    3 +++
 1 file changed, 3 insertions(+)

diff -puN scripts/get_maintainer.pl~get_maintainer-add-no-foo-options-to-help scripts/get_maintainer.pl
--- a/scripts/get_maintainer.pl~get_maintainer-add-no-foo-options-to-help
+++ a/scripts/get_maintainer.pl
@@ -845,6 +845,9 @@ Notes:
       Entries in this file can be any command line argument.
       This file is prepended to any additional command line arguments.
       Multiple lines and # comments are allowed.
+  Most options have both positive and negative forms.
+      The negative forms for --<foo> are --no<foo> and --no-<foo>.
+
 EOT
 }
 
_

Patches currently in -mm which might be from computersforpeace@gmail.com are

get_maintainer-add-missing-documentation-for-git-blame-signatures.patch
get_maintainer-its-pattern-depth-not-pattern-depth.patch
get_maintainer-add-no-foo-options-to-help.patch
get_maintainer-r-list-reviewer-is-on-by-default.patch

