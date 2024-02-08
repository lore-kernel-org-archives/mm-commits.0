Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4506867A0F
	for <mm-commits@vger.kernel.org>; Thu,  8 Feb 2024 05:21:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707369689; cv=none; b=Fcb0mG/OTYRkubHdvCO+nnU9DqBctYgkqKfoXfGdppk6/6IBmDu20JcA6dOKSMzwRaPs2slP+5v+grnl0C7b8Joy5GJ0NZl8iRvB6Fd6DHlMnPX0qnNIgfaZk/EkGz9IzAkeLe3St4bJtRc+fynhqauG4W+GHth9D4Ggo03qz6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707369689; c=relaxed/simple;
	bh=MuoMBJGrTotjHyzK+TD8y+rGfZH7bMmF6OlTIH8YUV8=;
	h=Date:To:From:Subject:Message-Id; b=LxgywCAZcYYV5gzR2Fkffr9OByEKqhg5639HOYOBWRnYQDeyhRFImw9DCbakF8boPAcq3uAeDLZ2KE06VKQil6QEQRgBr1Oh20qYqaKoYelDRp2/qhzDyLvQTqC5A5xXBIJEM4VCGQJbr3ubMyV5heuI39/Zdl4lgpiUi5edEH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=d6fDeIKA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="d6fDeIKA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2C47C43390;
	Thu,  8 Feb 2024 05:21:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707369688;
	bh=MuoMBJGrTotjHyzK+TD8y+rGfZH7bMmF6OlTIH8YUV8=;
	h=Date:To:From:Subject:From;
	b=d6fDeIKAO+K9RR3A7ByPhiezI+D6iWmnBBuqUAfWW3RVlbadZfqxDh17fa+uB21Dt
	 xtmmw+MUd0VnB+WftCULLfVePRLmoEukZ8EIUHIJWKX7CsSkbQH6sthlUyWf0H47a4
	 8HGjhwLXgvUdfPatvo/whEGwEuCOdVUvjblV2mU8=
Date: Wed, 07 Feb 2024 21:21:28 -0800
To: mm-commits@vger.kernel.org,namhyung@kernel.org,mike.leach@linaro.org,james.clark@arm.com,irogers@google.com,acme@kernel.org,leo.yan@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-update-my-email-address.patch removed from -mm tree
Message-Id: <20240208052128.B2C47C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: Leo Yan has moved
has been removed from the -mm tree.  Its filename was
     maintainers-update-my-email-address.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Leo Yan <leo.yan@linux.dev>
Subject: MAINTAINERS: Leo Yan has moved
Date: Thu, 1 Feb 2024 10:10:08 +0800

I will lose access to my @linaro.org email address next week, update the
MAINTAINERS file and map it in .mailmap with the new email address.

Link: https://lkml.kernel.org/r/20240201021022.886-1-leo.yan@linux.dev
Signed-off-by: Leo Yan <leo.yan@linux.dev>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Ian Rogers <irogers@google.com>
Cc: James Clark <james.clark@arm.com>
Cc: Mike Leach <mike.leach@linaro.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap    |    1 +
 MAINTAINERS |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

--- a/.mailmap~maintainers-update-my-email-address
+++ a/.mailmap
@@ -345,6 +345,7 @@ Leonid I Ananiev <leonid.i.ananiev@intel
 Leon Romanovsky <leon@kernel.org> <leon@leon.nu>
 Leon Romanovsky <leon@kernel.org> <leonro@mellanox.com>
 Leon Romanovsky <leon@kernel.org> <leonro@nvidia.com>
+Leo Yan <leo.yan@linux.dev> <leo.yan@linaro.org>
 Liam Mark <quic_lmark@quicinc.com> <lmark@codeaurora.org>
 Linas Vepstas <linas@austin.ibm.com>
 Linus Lüssing <linus.luessing@c0d3.blue> <linus.luessing@ascom.ch>
--- a/MAINTAINERS~maintainers-update-my-email-address
+++ a/MAINTAINERS
@@ -17183,7 +17183,7 @@ R:	John Garry <john.g.garry@oracle.com>
 R:	Will Deacon <will@kernel.org>
 R:	James Clark <james.clark@arm.com>
 R:	Mike Leach <mike.leach@linaro.org>
-R:	Leo Yan <leo.yan@linaro.org>
+R:	Leo Yan <leo.yan@linux.dev>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Supported
 F:	tools/build/feature/test-libopencsd.c
_

Patches currently in -mm which might be from leo.yan@linux.dev are


