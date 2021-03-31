Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA61CC433E0
	for <mm-commits@archiver.kernel.org>; Wed, 31 Mar 2021 08:26:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9862A619BC
	for <mm-commits@archiver.kernel.org>; Wed, 31 Mar 2021 08:26:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229759AbhCaIZr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 31 Mar 2021 04:25:47 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:44849 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232113AbhCaIZV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 31 Mar 2021 04:25:21 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4F9KBL5dq1z9sW4;
        Wed, 31 Mar 2021 19:25:14 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1617179119;
        bh=7m3QX4rYDIMqI5uM5XstLo8fYxaVC/CMG3CC8GuxK10=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dU+9hAMvw9Z6VASjOd9K0fqoV6yEYZnqIqvcG6PcmbnyO7kJ9APTVjhCS96saxcVj
         lb7ESrZ25MhNPabqaiwvHytcPciKEToEe+7wiz0p3FdN2xxQ1J0H+MU00rJORwB3dc
         je6Ctanx3JYJlyka9lYn3QqLtUBFklJAHRjFZ9/dqPpWW9JfRUN14U4DWa482+bEPQ
         FZjoVuuiAcpu1B6Dg1ThHXyrB3RJAhQk/DAxcp1M9f5sj/gBaFk0uUbg91Pf5z1OuK
         F3UeofAWOy+B9nkTRrKhJAIm8gzoZ6gB5J/qxi9h8V9LX473ZdyvgQ1xcQu558vELM
         npnkguDaEHaow==
Date:   Wed, 31 Mar 2021 19:25:13 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     akpm@linux-foundation.org
Cc:     colin.king@canonical.com, dan.carpenter@oracle.com,
        mm-commits@vger.kernel.org, npiggin@gmail.com, urezki@gmail.com,
        willy@infradead.org
Subject: Re: +
 mm-vmalloc-improve-allocation-failure-error-messages-fix.patch added to -mm
 tree
Message-ID: <20210331192513.65cbc387@canb.auug.org.au>
In-Reply-To: <20210331051005.Q09qN03sH%akpm@linux-foundation.org>
References: <20210331051005.Q09qN03sH%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/Kuas8m=sJ4TaBVvBJxf04_s";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

--Sig_/Kuas8m=sJ4TaBVvBJxf04_s
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Tue, 30 Mar 2021 22:10:05 -0700 akpm@linux-foundation.org wrote:
>
> The patch titled
>      Subject: mm/vmalloc: print correct vmalloc allocation size
> has been added to the -mm tree.  Its filename is
>      mm-vmalloc-improve-allocation-failure-error-messages-fix.patch

Added to linux-next today.

--=20
Cheers,
Stephen Rothwell

--Sig_/Kuas8m=sJ4TaBVvBJxf04_s
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmBkMeoACgkQAVBC80lX
0Gy+oAgAl3QYNExn9EZPiqmhj39VAeQuuQBhm1FLNwPSYJJjvDwRYYRqw4GxQ3aq
bUzrRWgCDpAQkygGNdnFOokfKTHFvWGZK031/P+rjlzDp3LF+xjumOcjigIYgqlr
r2Ie1YCNKG7HGsH8hhPmUhGM0AOcfhMPXBdcoM9m9yKE/j5m39z8VyRppxC4WHY7
GghQubYbkcpo8cdWwwuFsDgI8tRi9DZO0qEIRONGRGguDzi5FPoJ2INq0Ghkh01+
Gi3aQjJvPixxLqi+lNB5SgjkUsVVJkhAfoizhMWXcQuU5FGaOfg26bfKaEfC0fuS
FhZv8kpMbDISgTiEDcvVuurT81+Htg==
=lJ9B
-----END PGP SIGNATURE-----

--Sig_/Kuas8m=sJ4TaBVvBJxf04_s--
