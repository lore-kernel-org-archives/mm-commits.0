From: akpm@linux-foundation.org
Subject: [patch 16/27] mailmap: add codeaurora.org names for nameless
 email commits
Date: Tue, 10 Jan 2017 16:57:57 -0800
Message-ID: <58758315.5N/Sk5BOlC4RRKgN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33448 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759925AbdAKA6E (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 Jan 2017 19:58:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, sboyd@codeaurora.org, andy.gross@linaro.org, spjoshi@codeaurora.org, subashab@codeaurora.org, subhashj@codeaurora.org, twp@codeaurora.org

From: Stephen Boyd <sboyd@codeaurora.org>
Subject: mailmap: add codeaurora.org names for nameless email commits

Some codeaurora.org emails have crept in but the names don't exist for
them.  Add the names for the emails so git can match everyone up.

Link: http://lkml.kernel.org/r/20170104194611.25933-1-sboyd@codeaurora.org
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Cc: Sarangdhar Joshi <spjoshi@codeaurora.org>
Cc: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Cc: Subhash Jadavani <subhashj@codeaurora.org>
Cc: Thomas Pedersen <twp@codeaurora.org>
Cc: Andy Gross <andy.gross@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN .mailmap~mailmap-add-codeauroraorg-names-for-nameless-email-commits .mailmap
--- a/.mailmap~mailmap-add-codeauroraorg-names-for-nameless-email-commits
+++ a/.mailmap
@@ -137,6 +137,7 @@ Ricardo Ribalda Delgado <ricardo.ribalda
 Rudolf Marek <R.Marek@sh.cvut.cz>
 Rui Saraiva <rmps@joel.ist.utl.pt>
 Sachin P Sant <ssant@in.ibm.com>
+Sarangdhar Joshi <spjoshi@codeaurora.org>
 Sam Ravnborg <sam@mars.ravnborg.org>
 Santosh Shilimkar <ssantosh@kernel.org>
 Santosh Shilimkar <santosh.shilimkar@oracle.org>
@@ -150,10 +151,13 @@ Shuah Khan <shuah@kernel.org> <shuah.kh@
 Simon Kelley <simon@thekelleys.org.uk>
 Stéphane Witzmann <stephane.witzmann@ubpmes.univ-bpclermont.fr>
 Stephen Hemminger <shemminger@osdl.org>
+Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
+Subhash Jadavani <subhashj@codeaurora.org>
 Sudeep Holla <sudeep.holla@arm.com> Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
 Sumit Semwal <sumit.semwal@ti.com>
 Tejun Heo <htejun@gmail.com>
 Thomas Graf <tgraf@suug.ch>
+Thomas Pedersen <twp@codeaurora.org>
 Tony Luck <tony.luck@intel.com>
 Tsuneo Yoshioka <Tsuneo.Yoshioka@f-secure.com>
 Uwe Kleine-König <ukleinek@informatik.uni-freiburg.de>
_
