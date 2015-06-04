From: akpm@linux-foundation.org
Subject: + checkpatch-remove-local-from-codespell-path.patch added to -mm
 tree
Date: Thu, 04 Jun 2015 15:17:32 -0700
Message-ID: <5570ce7c.o9HMEuh5YNz0QAXi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43685 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753181AbbFDWRd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Jun 2015 18:17:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: maxim.uvarov@linaro.org, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: remove local from codespell path
has been added to the -mm tree.  Its filename is
     checkpatch-remove-local-from-codespell-path.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-remove-local-from-codespell-path.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-remove-local-from-codespell-path.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Maxim Uvarov <maxim.uvarov@linaro.org>
Subject: checkpatch: remove local from codespell path

local is typically used for manually installed apps.
For apps installed from distro the right path is /usr/share.

Signed-off-by: Maxim Uvarov <maxim.uvarov@linaro.org>
Acked-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-remove-local-from-codespell-path scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-remove-local-from-codespell-path
+++ a/scripts/checkpatch.pl
@@ -50,7 +50,7 @@ my $minimum_perl_version = 5.10.0;
 my $min_conf_desc_length = 4;
 my $spelling_file = "$D/spelling.txt";
 my $codespell = 0;
-my $codespellfile = "/usr/local/share/codespell/dictionary.txt";
+my $codespellfile = "/usr/share/codespell/dictionary.txt";
 my $color = 1;
 
 sub help {
@@ -95,7 +95,7 @@ Options:
   --ignore-perl-version      override checking of perl version.  expect
                              runtime errors.
   --codespell                Use the codespell dictionary for spelling/typos
-                             (default:/usr/local/share/codespell/dictionary.txt)
+                             (default:/usr/share/codespell/dictionary.txt)
   --codespellfile            Use this codespell dictionary
   --color                    Use colors when output is STDOUT (default: on)
   -h, --help, --version      display this help and exit
_

Patches currently in -mm which might be from maxim.uvarov@linaro.org are

checkpatch-remove-local-from-codespell-path.patch

