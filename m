Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 915F547F59
	for <mm-commits@vger.kernel.org>; Wed, 27 Dec 2023 21:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QBp+5A/D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E705C433C8;
	Wed, 27 Dec 2023 21:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703713033;
	bh=lsAzRxuzpbCFv74djAQyVG+NQOSfnCs4d2xCf9l7+hI=;
	h=Date:To:From:Subject:From;
	b=QBp+5A/Dwxlh5LV2LSHlQIcPwos3xom8t1BFMq4OAlJWo6Y5ktZTpto29b66dMsN+
	 T4fTRbSNWtpuZakhvATFCXhRA/azKjVyNJvdV662dNi20NizKRGmnBFPrkFyLmoUBC
	 K/lRwL/S/veevtQX/egrVgB3rsE8k3F/Z3Ka6F9g=
Date: Wed, 27 Dec 2023 13:37:12 -0800
To: mm-commits@vger.kernel.org,quic_bjorande@quicinc.com,o.rempel@pengutronix.de,matttbe@kernel.org,matt@ranostay.sg,kuba@kernel.org,konrad.dybcio@linaro.org,jikos@kernel.org,heiko@sntech.de,othacehe@gnu.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-add-entries-for-mathieu-othacehe.patch added to mm-hotfixes-unstable branch
Message-Id: <20231227213713.3E705C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mailmap: add entries for Mathieu Othacehe
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mailmap-add-entries-for-mathieu-othacehe.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-add-entries-for-mathieu-othacehe.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Mathieu Othacehe <othacehe@gnu.org>
Subject: mailmap: add entries for Mathieu Othacehe
Date: Sat, 23 Dec 2023 15:42:22 +0100

Add my gnu.org mail address.

Link: https://lkml.kernel.org/r/20231223144226.25740-1-othacehe@gnu.org
Signed-off-by: Mathieu Othacehe <othacehe@gnu.org>
Cc: Bjorn Andersson <quic_bjorande@quicinc.com>
Cc: Heiko Stuebner <heiko@sntech.de>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Jiri Kosina <jikos@kernel.org>
Cc: Konrad Dybcio <konrad.dybcio@linaro.org>
Cc: Matthieu Baerts <matttbe@kernel.org>
Cc: Matt Ranostay <matt@ranostay.sg>
Cc: Oleksij Rempel <o.rempel@pengutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/.mailmap~mailmap-add-entries-for-mathieu-othacehe
+++ a/.mailmap
@@ -370,7 +370,7 @@ Martin Kepplinger <martink@posteo.de> <m
 Martin Kepplinger <martink@posteo.de> <martin.kepplinger@puri.sm>
 Martin Kepplinger <martink@posteo.de> <martin.kepplinger@theobroma-systems.com>
 Martyna Szapar-Mudlaw <martyna.szapar-mudlaw@linux.intel.com> <martyna.szapar-mudlaw@intel.com>
-Mathieu Othacehe <m.othacehe@gmail.com>
+Mathieu Othacehe <m.othacehe@gmail.com> <othacehe@gnu.org>
 Mat Martineau <martineau@kernel.org> <mathew.j.martineau@linux.intel.com>
 Mat Martineau <martineau@kernel.org> <mathewm@codeaurora.org>
 Matthew Wilcox <willy@infradead.org> <matthew.r.wilcox@intel.com>
_

Patches currently in -mm which might be from othacehe@gnu.org are

mailmap-add-entries-for-mathieu-othacehe.patch

