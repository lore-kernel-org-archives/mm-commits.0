Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AB4A7A13A
	for <mm-commits@vger.kernel.org>; Fri, 26 Sep 2025 20:00:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758916834; cv=none; b=G4nIb4VGU6wci+9Ip9tGvk9xu3q/qkHKxGH8Yx8trTESW9jqdp6wzX+Dg52YC+KyZszfqpVzEFZVzaR/vanbGSvCH5E/Y+OQH9Ap/FLb2YiduKgekAwqzelT567wBA0lbmjnObSHcagvi6NMKoJBwi1VYxZCPkjzC/eaKrj9ZGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758916834; c=relaxed/simple;
	bh=iWOHqoZgUIZutOdPu4ZUUlQ8mlif5UHIyADZeywY/2k=;
	h=Date:To:From:Subject:Message-Id; b=BdQMo7Jx8D2NL8//tv7AsyRjLSk4ArEFRkgo2+u+OrDq8M4d0evuWpB9EELbZ97MaTSJggUxvBAh/v2/Ng9QSQEjd64NhbXM5ccObUjj6aq46+aI6aRpBtNw28zvr+LtTcshQ6pwwEPRitVG9mM9C8d40rS3PMHmb/AxE3FJ02g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YzHK0bfJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YzHK0bfJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA8CDC4CEF4;
	Fri, 26 Sep 2025 20:00:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758916831;
	bh=iWOHqoZgUIZutOdPu4ZUUlQ8mlif5UHIyADZeywY/2k=;
	h=Date:To:From:Subject:From;
	b=YzHK0bfJrJpm/Pu75rMdwtf6Un8/3+JONciW0HfWXnxK1+XYM6DAR1puQRYs4nXbc
	 fE7rCt+EaRUJ8fdFJiJWqVlx7yTUpN3CEsMu1LiXyEMPGk/u/Wph4As9WHV1AW42YC
	 EV5ei+jm8XJl/4XRzAD5Fm+hsfzqXc1XiiUYbo8I=
Date: Fri, 26 Sep 2025 13:00:31 -0700
To: mm-commits@vger.kernel.org,sln@onemain.com,jarkko@kernel.org,carlos.bilbao@kernel.org,andersson@kernel.org,sibi.sankar@oss.qualcomm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-update-sibi-sankars-email-address.patch added to mm-nonmm-unstable branch
Message-Id: <20250926200031.CA8CDC4CEF4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: update Sibi Sankar's email address
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     maintainers-update-sibi-sankars-email-address.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-update-sibi-sankars-email-address.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Sibi Sankar <sibi.sankar@oss.qualcomm.com>
Subject: MAINTAINERS: update Sibi Sankar's email address
Date: Fri, 26 Sep 2025 15:04:26 +0530

Switch to using oss.qualcomm.com email ID in the MAINTAINERS file.  Also
update mailmap to ensure proper attribution across historical commits.

Link: https://lkml.kernel.org/r/20250926093426.1735334-1-sibi.sankar@oss.qualcomm.com
Signed-off-by: Sibi Sankar <sibi.sankar@oss.qualcomm.com>
Cc: Bjorn Andersson <andersson@kernel.org>
Cc: Carlos Bilbao <carlos.bilbao@kernel.org>
Cc: Jarkko Sakkinen <jarkko@kernel.org>
Cc: Shannon Nelson <sln@onemain.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap    |    3 ++-
 MAINTAINERS |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/.mailmap~maintainers-update-sibi-sankars-email-address
+++ a/.mailmap
@@ -716,7 +716,8 @@ Shuah Khan <shuah@kernel.org> <shuahkhan
 Shuah Khan <shuah@kernel.org> <shuah.khan@hp.com>
 Shuah Khan <shuah@kernel.org> <shuahkh@osg.samsung.com>
 Shuah Khan <shuah@kernel.org> <shuah.kh@samsung.com>
-Sibi Sankar <quic_sibis@quicinc.com> <sibis@codeaurora.org>
+Sibi Sankar <sibi.sankar@oss.qualcomm.com> <sibis@codeaurora.org>
+Sibi Sankar <sibi.sankar@oss.qualcomm.com> <quic_sibis@quicinc.com>
 Sid Manning <quic_sidneym@quicinc.com> <sidneym@codeaurora.org>
 Simon Arlott <simon@octiron.net> <simon@fire.lp0.eu>
 Simona Vetter <simona.vetter@ffwll.ch> <daniel.vetter@ffwll.ch>
--- a/MAINTAINERS~maintainers-update-sibi-sankars-email-address
+++ a/MAINTAINERS
@@ -20720,7 +20720,7 @@ F:	Documentation/devicetree/bindings/pow
 F:	drivers/pmdomain/qcom/cpr.c
 
 QUALCOMM CPUCP MAILBOX DRIVER
-M:	Sibi Sankar <quic_sibis@quicinc.com>
+M:	Sibi Sankar <sibi.sankar@oss.qualcomm.com>
 L:	linux-arm-msm@vger.kernel.org
 S:	Supported
 F:	Documentation/devicetree/bindings/mailbox/qcom,cpucp-mbox.yaml
_

Patches currently in -mm which might be from sibi.sankar@oss.qualcomm.com are

maintainers-update-sibi-sankars-email-address.patch

