Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9548150A98
	for <mm-commits@vger.kernel.org>; Mon, 19 Feb 2024 23:52:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708386754; cv=none; b=fTDfVQEVwgqjS3YvZ9PFWqldgdGRE6c1G5bxq/z2L7D0euo6wJzh0qBIeOpkUPvjRj9zfXqYcT52Ung6hx18BpL4IVxUgp8qq1gaM0CkOSuAtZUlRkLzhnhUNNMa6w1w9/VyniT2gqx80qBnk6GSrY6pRwU1SPP9S+lIriuBufc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708386754; c=relaxed/simple;
	bh=I80u7/J2SChSAM4qoLTKmmujZIuAag8qvdeQMkwzr8Y=;
	h=Date:To:From:Subject:Message-Id; b=c6fiZlqjr2P9QWBC9N7Qsc4ZL9JuoQogTjUENE02s289HWVVXWgbd3LwHt3WBHJndOeAm8pKnqBreDXdGPhWeunAgoIr7D1mfCGigA+Po/L8QeQtLZqnrdPnjrLkT2I9JfNsLB2mn9WrqBLsjXKpMRozWL5y8QIasTHeOFx5jgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=w3IEBxjf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="w3IEBxjf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CB43C433F1;
	Mon, 19 Feb 2024 23:52:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708386754;
	bh=I80u7/J2SChSAM4qoLTKmmujZIuAag8qvdeQMkwzr8Y=;
	h=Date:To:From:Subject:From;
	b=w3IEBxjfRpHg48LgcqyAwF11szzVjD530VFwa1YsROqSMrTWaEF69mw3vm7pKbQvE
	 xdJ3jbCrPYC+jcymZM7DwrX3PoZ+J/7QfuPmIHQaExTo5VYsEY5qWmhm5t2RGasH/c
	 MARLibZtwP9C4jB5YPg5rhud6OsLrV4b0qs4eJCo=
Date: Mon, 19 Feb 2024 15:52:33 -0800
To: mm-commits@vger.kernel.org,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-mailmap-update-the-email-address.patch added to mm-hotfixes-unstable branch
Message-Id: <20240219235234.2CB43C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: mailmap: update Shakeel's email address
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-mailmap-update-the-email-address.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-mailmap-update-the-email-address.patch

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
@@ -552,6 +552,7 @@ Senthilkumar N L <quic_snlakshm@quicinc.
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

maintainers-mailmap-update-the-email-address.patch

