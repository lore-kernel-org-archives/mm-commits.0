Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0939E41C67
	for <mm-commits@vger.kernel.org>; Wed, 31 Jan 2024 06:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706682831; cv=none; b=P6jGm3a85uEXj4zgyChCd3k5ShEQLFoqc+wG93flO7gLdZr4/y1RPPVbxweEW8rC1Of7aIFhLQqfVxDjmN0DzvK9DcJrRv55r4daSKOtYg5m7nHEd6nIlg4ZjuJCGZmA96m9Wx1icQ4iPd0/y8/FLWhn6L9IlXsTKez4xk8ZR44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706682831; c=relaxed/simple;
	bh=QP4UoZQSNMEPqZwUmjR8GNHRhefBz/lBFlW3fYXlFhU=;
	h=Date:To:From:Subject:Message-Id; b=Jd3f3JBMrrhVXtVHBuTPxtTsJiAJiP+LxvoUakjPBFBav983Y7WeDqIRen6WbIai2eOYLO7+odSPCJOm+oDvUYQapEno855hrpXEP2xk/z0IuRY8AnzlLgH+Pus6gp+g/rR7l59ua+Z0J1oXNIm/0nCHmLUQKmP6trrauyNVFtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=F+aBolDH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="F+aBolDH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E918C433F1;
	Wed, 31 Jan 2024 06:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706682830;
	bh=QP4UoZQSNMEPqZwUmjR8GNHRhefBz/lBFlW3fYXlFhU=;
	h=Date:To:From:Subject:From;
	b=F+aBolDH6yHrQmy0hVcgW8g+jZntaOkzMJY9QSN3ZS93YbTr/ZfabZ66LpLfTstl2
	 +RPn8xSyBtzglyy2ChidEV/VDF5EYw5dSeAvSJ6sZkkU2AxRQYQgkk3aqk6oQ7AJzt
	 dUqF5GusdIryowezorIcL5bJhNa0HrDKKgz8XGkU=
Date: Tue, 30 Jan 2024 22:33:36 -0800
To: mm-commits@vger.kernel.org,quic_tsoni@quicinc.com,quic_eberman@quicinc.com,john@jmoon.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mailmap-switch-email-address-for-john-moon.patch added to mm-hotfixes-unstable branch
Message-Id: <20240131063349.8E918C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mailmap: switch email address for John Moon
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mailmap-switch-email-address-for-john-moon.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mailmap-switch-email-address-for-john-moon.patch

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
From: John Moon <john@jmoon.dev>
Subject: mailmap: switch email address for John Moon
Date: Wed, 31 Jan 2024 03:43:18 +0000

Add current email address as QUIC email is no longer active.

Link: https://lkml.kernel.org/r/20240131034311.46706-1-john@jmoon.dev
Signed-off-by: John Moon <john@jmoon.dev>
Acked-by: Trilok Soni <quic_tsoni@quicinc.com>
Cc: Elliot Berman <quic_eberman@quicinc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-switch-email-address-for-john-moon
+++ a/.mailmap
@@ -289,6 +289,7 @@ Johan Hovold <johan@kernel.org> <johan@h
 John Crispin <john@phrozen.org> <blogic@openwrt.org>
 John Fastabend <john.fastabend@gmail.com> <john.r.fastabend@intel.com>
 John Keeping <john@keeping.me.uk> <john@metanate.com>
+John Moon <john@jmoon.dev> <quic_johmoo@quicinc.com>
 John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
 John Stultz <johnstul@us.ibm.com>
 <jon.toppins+linux@gmail.com> <jtoppins@cumulusnetworks.com>
_

Patches currently in -mm which might be from john@jmoon.dev are

mailmap-switch-email-address-for-john-moon.patch

