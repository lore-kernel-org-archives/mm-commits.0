Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A37E12E49
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 19:07:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aay427qR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22EEFC433C7;
	Fri, 29 Dec 2023 19:07:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703876853;
	bh=dNC1k+9C1R5LT35hlaCya/Lb2wMYyH6uXkqpDqIz2+I=;
	h=Date:To:From:Subject:From;
	b=aay427qRVznfXwLoZ5I78oAohZJAHc4RpwJCZa2VzulcMqH4f+LLr/oisoKKXoA83
	 3ghOZa1HMQ2ImNXWRl8iAjlXx/AykKusBKyyO88yTepf0K+Y/wvkoP2B55YrFWwv3T
	 bwoYie3ik+1RS2CMI0985ttu0/sfpzfInax4Y7i0=
Date: Fri, 29 Dec 2023 11:07:32 -0800
To: mm-commits@vger.kernel.org,quic_bjorande@quicinc.com,o.rempel@pengutronix.de,matttbe@kernel.org,matt@ranostay.sg,kuba@kernel.org,konrad.dybcio@linaro.org,jikos@kernel.org,heiko@sntech.de,othacehe@gnu.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mailmap-add-entries-for-mathieu-othacehe.patch removed from -mm tree
Message-Id: <20231229190733.22EEFC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mailmap: add entries for Mathieu Othacehe
has been removed from the -mm tree.  Its filename was
     mailmap-add-entries-for-mathieu-othacehe.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


