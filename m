Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEF43C63777
	for <mm-commits@archiver.kernel.org>; Mon, 30 Nov 2020 21:13:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DFD15206A5
	for <mm-commits@archiver.kernel.org>; Mon, 30 Nov 2020 21:13:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b="mw1L5AEd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388450AbgK3VNb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 30 Nov 2020 16:13:31 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:34547 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388399AbgK3VNb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 30 Nov 2020 16:13:31 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4ClHxp4rfJz9sRK;
        Tue,  1 Dec 2020 08:12:46 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1606770769;
        bh=2vkZLgqWOoPpUIEkznG61Kkv6iiATflE4c/udC18Vbo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mw1L5AEdNLycSE0yT8txNndoM0PvQlWE2MvV5gGXjJpM+uixxe8GB4PXL6oijDmDS
         0ixN/LaiFLkHsF8jonIkOHqm9HQ6LE9LdrWUGxRtISjdgkOHVXQoKrSPr0/arEg+20
         CiBOEVtM0wz8xWq/xQdWyHy0NVs2XTxMbLRztRbmvnPBYDfsvlSXUTqMPkKNGiyJVr
         bjsVddWc8w6nV320WbfZN648RLkmbebdFB0cMVmB2m0Jn9ayJxb/ZkhqDY/Xc1ai2Y
         9Ei2PjbUsq1onqOXRx03F39rVFXcg6TcTVYTYqbWQ9AfGDgOCjIitPiJJO4QQa60wq
         q97WD1etMU0Ow==
Date:   Tue, 1 Dec 2020 08:12:45 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     akpm@linux-foundation.org
Cc:     alex.shi@linux.alibaba.com, alexander.h.duyck@linux.intel.com,
        guro@fb.com, hannes@cmpxchg.org, laoar.shao@gmail.com,
        lstoakes@gmail.com, mhocko@kernel.org, mm-commits@vger.kernel.org,
        richard.weiyang@gmail.com, shakeelb@google.com
Subject: Re: [failures]
 mm-memcg-bail-out-early-when-memcg-in-mem_cgroup_lruvec.patch removed from
 -mm tree
Message-ID: <20201201081245.1154aee2@canb.auug.org.au>
In-Reply-To: <20201130202244.1HtlYOuKE%akpm@linux-foundation.org>
References: <20201130202244.1HtlYOuKE%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/rflLoh8nLz9jTJbdMtnGyEX";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

--Sig_/rflLoh8nLz9jTJbdMtnGyEX
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Mon, 30 Nov 2020 12:22:44 -0800 akpm@linux-foundation.org wrote:
>
> The patch titled
>      Subject: mm/memcg: bail out early when !memcg in mem_cgroup_lruvec
> has been removed from the -mm tree.  Its filename was
>      mm-memcg-bail-out-early-when-memcg-in-mem_cgroup_lruvec.patch
>=20
> This patch was dropped because it had testing failures

I have removed that patch from linux-next today.

--=20
Cheers,
Stephen Rothwell

--Sig_/rflLoh8nLz9jTJbdMtnGyEX
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl/FYE0ACgkQAVBC80lX
0GyiOwgAmZDtqaG1rMQ/nzYcd5ZiFDvUEMa0ts3NxN/t3LjeEHWeAJOztiyN7ddR
p+zOwYKba7xEnR8jNsMUWY88DK7pxCj3XGT1usepSXo7bohCCx/tjomORY+hSig9
SGA2WDKdYNfgkdm+Q7PnNQsI1qJgvd3e2ITcEJYVFiIZgqumXPRln+ctOZlg8Fw9
+KkpyU1hR1FtgM+7QFDgPV/znvBDFdsr4U6c8QaBHY0i5MndUWXucRGzzdharl0f
rp0GOmW8ElXSvYhRr5HimOR/ocD8VM15foQA4jy5dM+9AV4kOsaK9i5+DQMnR5yC
ENrUNP3aHax8WX8FDDoVsHCusJWkWA==
=qe9s
-----END PGP SIGNATURE-----

--Sig_/rflLoh8nLz9jTJbdMtnGyEX--
