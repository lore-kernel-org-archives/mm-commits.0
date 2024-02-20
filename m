Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3778D152DF6
	for <mm-commits@vger.kernel.org>; Tue, 20 Feb 2024 22:22:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708467755; cv=none; b=hh/Q8kbFCcYWZx1HdZ/fVbVnrjs5jEuoSPdlYYODns1/gpE7DoSmaQlZo37TJ1Tr8HVG2+t78aGq/biEsClB/zB02iNQdcILcOkZqpf9TcLs7lgXlul9Q4oX9ORxhRplRYJ3LENS/Z6mcA7ZCUnEtT1RmW0buIq+TDG8Ydyr1VQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708467755; c=relaxed/simple;
	bh=bbpDQ5qSnae2YVXdoUkOgUTmCnBgAPcusVUF/UwJKHw=;
	h=Date:To:From:Subject:Message-Id; b=Ffb2dyu2iVpXh6bHyhA3LGZvJuHodx/HmH4BUw8G1ZOY9LsylKe8qh5qQ3hl1IrAGBo3JDBya5x3XI84AfkvyypBzwxqaLhR4LIA8Alapjs+DngXHa1jLwMuHOFT1jcbrR6IcJxzFi5xbujUqiKSxcQPz4rb3HI6qrYdsPptDrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xDFJGPQ+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xDFJGPQ+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A25ADC433F1;
	Tue, 20 Feb 2024 22:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708467754;
	bh=bbpDQ5qSnae2YVXdoUkOgUTmCnBgAPcusVUF/UwJKHw=;
	h=Date:To:From:Subject:From;
	b=xDFJGPQ+PVderB3Egb1vW06YzswcW3a6Jo6hMBFLejnHxmmKS9UBtZ7LqV70hLnbD
	 nV4loCt39hqZ2j2vvikQsfkeo1H5EpbkQyPXP9/j5ugFXVwC+bjnsdGVZr3JNxUozf
	 NlEU6a7lZp1MVyYGd5zfWv+WeEqi4kWhfAG50gZU=
Date: Tue, 20 Feb 2024 14:22:34 -0800
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-mailmap-update-the-email-address.patch removed from -mm tree
Message-Id: <20240220222234.A25ADC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: mailmap: update Shakeel's email address
has been removed from the -mm tree.  Its filename was
     maintainers-mailmap-update-the-email-address.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: MAINTAINERS: mailmap: update Shakeel's email address
Date: Mon, 19 Feb 2024 12:50:50 -0800

Moving to linux.dev based email for kernel work.

Link: https://lkml.kernel.org/r/20240219205050.887810-1-shakeel.butt@linux.dev
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap    |    1 +
 MAINTAINERS |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

--- a/.mailmap~maintainers-mailmap-update-the-email-address
+++ a/.mailmap
@@ -553,6 +553,7 @@ Senthilkumar N L <quic_snlakshm@quicinc.
 Serge Hallyn <sergeh@kernel.org> <serge.hallyn@canonical.com>
 Serge Hallyn <sergeh@kernel.org> <serue@us.ibm.com>
 Seth Forshee <sforshee@kernel.org> <seth.forshee@canonical.com>
+Shakeel Butt <shakeel.butt@linux.dev> <shakeelb@google.com>
 Shannon Nelson <shannon.nelson@amd.com> <snelson@pensando.io>
 Shannon Nelson <shannon.nelson@amd.com> <shannon.nelson@intel.com>
 Shannon Nelson <shannon.nelson@amd.com> <shannon.nelson@oracle.com>
--- a/MAINTAINERS~maintainers-mailmap-update-the-email-address
+++ a/MAINTAINERS
@@ -5378,7 +5378,7 @@ CONTROL GROUP - MEMORY RESOURCE CONTROLL
 M:	Johannes Weiner <hannes@cmpxchg.org>
 M:	Michal Hocko <mhocko@kernel.org>
 M:	Roman Gushchin <roman.gushchin@linux.dev>
-M:	Shakeel Butt <shakeelb@google.com>
+M:	Shakeel Butt <shakeel.butt@linux.dev>
 R:	Muchun Song <muchun.song@linux.dev>
 L:	cgroups@vger.kernel.org
 L:	linux-mm@kvack.org
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are


